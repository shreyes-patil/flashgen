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
    @State private var isAuthenticated = false
    @State private var isCheckingAuth = true
    
    init() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "944869000579-3g5qq0dniv8qep71q9nns3dchmobvgpa.apps.googleusercontent.com"
        )
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isCheckingAuth {
                    ProgressView()
                } else if isAuthenticated {
                    MainTabView()
                        .environment(\.flashcardRepository, repo)
                } else {
                    LoginView()
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .task {
                for await state in await SupabaseManager.shared.client.auth.authStateChanges {
                    await MainActor.run {
                        isAuthenticated = state.session != nil
                        isCheckingAuth = false
                    }
                }
            }
           
        }
    }
}
