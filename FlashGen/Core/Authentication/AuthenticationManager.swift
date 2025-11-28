import SwiftUI
import Supabase

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isGuestMode = false
    @Published var isLoading = true
    
    static let shared = AuthenticationManager()
    
    init() {
        Task {
            await checkSession()
            await setupAuthListener()
        }
    }
    
    func checkSession() async {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            self.isAuthenticated = session != nil
            // If we have a session, we are definitely not in guest mode (or we override it)
            if self.isAuthenticated {
                self.isGuestMode = false
            }
        } catch {
            self.isAuthenticated = false
        }
        self.isLoading = false
    }
    
    func setupAuthListener() async {
        for await state in await SupabaseManager.shared.client.auth.authStateChanges {
            self.isAuthenticated = state.session != nil
            if self.isAuthenticated {
                self.isGuestMode = false
            }
        }
    }
    
    func continueAsGuest() {
        self.isGuestMode = true
    }
    
    func signOut() async {
        do {
            // Clear local cache before signing out to prevent data leak to guest mode
            let repo = CachedFlashcardRepository()
            try await repo.clearLocalCache()
            
            try await SupabaseManager.shared.client.auth.signOut()
            self.isAuthenticated = false
            self.isGuestMode = false // Reset guest mode on sign out too, forcing login screen
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
