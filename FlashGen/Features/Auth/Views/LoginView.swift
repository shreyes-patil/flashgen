import SwiftUI
import GoogleSignIn
import Supabase

struct LoginView: View {
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    @State private var isSigningOut = false
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("FlashGen")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("AI-Powered Flashcards")
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
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "g.circle.fill")
                            Text("Sign in with Google")
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
                .disabled(isLoading)
                .padding(.horizontal, 32)
                
                if !authManager.isGuestMode {
                    Button(action: {
                        authManager.continueAsGuest()
                    }) {
                        Text("Continue as Guest")
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
        isLoading = true
        errorMessage = nil
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            errorMessage = "Unable to find root view controller"
            isLoading = false
            return
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                errorMessage = "Failed to get ID token"
                isLoading = false
                return
            }
            
        
            try await SupabaseManager.shared.client.auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .google,
                    idToken: idToken
                )
            )
          
            
        } catch {
            errorMessage = "Sign in failed: \(error.localizedDescription)"
            
        }
        
        isLoading = false
    }
    
    
}
