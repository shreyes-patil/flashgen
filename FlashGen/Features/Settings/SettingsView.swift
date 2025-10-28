//
//  SettingsView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI
import GoogleSignIn
import Supabase

struct SettingsView: View {
    @State private var isSigningOut = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Section {
                Button(role: .destructive, action: { Task { await signOut() } }) {
                    HStack {
                        if isSigningOut {
                            ProgressView()
                        }
                        Text("Sign out")
                    }
                }
                .disabled(isSigningOut)
            }
        }
        .navigationTitle("Settings")
    }

    private func signOut() async {
        await MainActor.run { isSigningOut = true; errorMessage = nil }
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            GIDSignIn.sharedInstance.signOut()
            NotificationCenter.default.post(name: NSNotification.Name("UserDidSignIn"), object: nil)
        } catch {
            await MainActor.run {
                errorMessage = "Sign out failed: \(error.localizedDescription)"
            }
        }
        await MainActor.run { isSigningOut = false }
    }
}

#Preview {
    SettingsView()
}
