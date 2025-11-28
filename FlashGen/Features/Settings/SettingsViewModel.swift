//
//  SettingsViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 10/29/25.
//

import Foundation
import SwiftUI
import GoogleSignIn
import Supabase

struct UserProfile {
    let name: String
    let email: String
    let photoURL: URL?
}

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var user: UserProfile?
    @Published var isLoading = false
    @Published var isSigningOut = false
    @Published var errorMessage: String?
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    func loadUserProfile() async {
        isLoading = true
        
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            
            let name = session.user.userMetadata["full_name"]?.value as? String
                ?? session.user.email ?? "User"
            let email = session.user.email ?? ""
            let photoURLString = session.user.userMetadata["avatar_url"]?.value as? String
            
            self.user = UserProfile(
                name: name,
                email: email,
                photoURL: photoURLString.flatMap { URL(string: $0) }
            )
        } catch {
            // Handle error
        }
        
        isLoading = false
    }
    
    private let repository: FlashcardRepository = CachedFlashcardRepository()
    @Published var isDeleting = false
    
    func signOut() async {
        isSigningOut = true
        errorMessage = nil
        
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            GIDSignIn.sharedInstance.signOut()
            
            // Notify app to show login screen
            NotificationCenter.default.post(name: NSNotification.Name("UserDidSignOut"), object: nil)
        } catch {
            errorMessage = "Sign out failed: \(error.localizedDescription)"
        }
        
        isSigningOut = false
    }
    
    func deleteAllSets() async {
        isDeleting = true
        errorMessage = nil
        
        do {
            try await repository.deleteAllSets()
        } catch {
            errorMessage = "Failed to delete sets: \(error.localizedDescription)"
        }
        
        isDeleting = false
    }
}
