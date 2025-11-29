//
//  FlashGenApp.swift
//  FlashGen
//
//  Created by Shreyas Patil on 2/1/25.
//

import SwiftUI
import GoogleSignIn

@main
struct FlashGenApp: App {
    private let repo: any FlashcardRepository = CachedFlashcardRepository()
    @StateObject private var authManager = AuthenticationManager.shared
    
    init() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "944869000579-3g5qq0dniv8qep71q9nns3dchmobvgpa.apps.googleusercontent.com"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isLoading {
                    ProgressView()
                } else if authManager.isAuthenticated || authManager.isGuestMode {
                    MainTabView()
                        .environment(\.flashcardRepository, repo)
                        .environmentObject(authManager)
                } else {
                    LoginView()
                        .environmentObject(authManager)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
