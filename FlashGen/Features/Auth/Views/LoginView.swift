import SwiftUI
import GoogleSignIn
import Supabase
import Supabase
import AuthenticationServices
import CryptoKit

struct LoginView: View {
    @State private var isGoogleLoading = false
    @State private var isAppleLoading = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    @State private var isSigningOut = false
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var currentNonce: String?
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .accessibilityLabel(Text(LocalizedStringKey("login.logo.accessibility_label")))
                    
                    Text(LocalizedStringKey("login.app_name"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(LocalizedStringKey("login.subtitle"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: { Task { await signInWithGoogle() } }) {
                    HStack {
                        if isGoogleLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "g.circle.fill")
                            Text(LocalizedStringKey("login.google_button"))
                                .fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight]))
                    .shadow(radius: 4)
                }
                .disabled(isGoogleLoading || isAppleLoading)
                .padding(.horizontal, 32)
                
                ZStack {
                    SignInWithAppleButton(
                        onRequest: { request in
                            let nonce = randomNonceString()
                            currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(nonce)
                        },
                        onCompletion: { result in
                            Task {
                                await signInWithApple(result: result)
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 50)
                    .clipShape(RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight]))
                    .shadow(radius: 4)
                    .overlay(
                        Group {
                            if isAppleLoading {
                                ZStack {
                                    Color.white
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                }
                            }
                        }
                    )
                }
                .padding(.horizontal, 32)
                .disabled(isGoogleLoading || isAppleLoading)
                
               
                
                if !authManager.isGuestMode {
                    Button(action: {
                        authManager.continueAsGuest()
                    }) {
                        Text(LocalizedStringKey("login.guest_button"))
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
                
                
                Spacer()
            }
        }
    }
    
    private func signInWithGoogle() async {
        isGoogleLoading = true
        errorMessage = nil
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = NSLocalizedString("login.error.root_view", comment: "")
            isGoogleLoading = false
            return
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                errorMessage = NSLocalizedString("login.error.id_token", comment: "")
                isGoogleLoading = false
                return
            }
            
        
            try await SupabaseManager.shared.client.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .google,
                    idToken: idToken
                )
            )
          
            
        } catch {
            errorMessage = String(format: NSLocalizedString("login.error.signin_failed", comment: ""), error.localizedDescription)
            
        }
        
        isGoogleLoading = false
        dismiss()
    }
    
    private func signInWithApple(result: Result<ASAuthorization, Error>) async {
        isAppleLoading = true
        errorMessage = nil
        
        do {
            let authorization = try result.get()
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                throw NetworkError.invalidResponse // Using generic error for now
            }
            
            guard let identityToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: identityToken, encoding: .utf8) else {
                throw NetworkError.invalidResponse
            }
            
            guard let nonce = currentNonce else {
                throw NetworkError.invalidResponse
            }
            
            try await SupabaseManager.shared.client.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .apple,
                    idToken: idTokenString,
                    nonce: nonce
                )
            )
            
        } catch {
            errorMessage = String(format: NSLocalizedString("login.error.apple_signin_failed", comment: ""), error.localizedDescription)
        }
        
        isAppleLoading = false
        dismiss()
    }
    
    // MARK: - Helpers
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
}
