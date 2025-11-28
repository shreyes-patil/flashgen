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
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showDeleteConfirmation = false
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showLoginSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                // User Profile Section
                Section {
                    if authManager.isGuestMode {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Guest User")
                                    .font(.headline)
                                Text("Sign in to save your flashcards")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    } else if let user = viewModel.user {
                        HStack {
                            // Profile picture
                            if let photoURL = user.photoURL {
                                AsyncImage(url: photoURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    } else if viewModel.isLoading {
                        HStack {
                            ProgressView()
                            Text("Loading profile...")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Account")
                }
                
                // App Info Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(viewModel.appVersion)
                            .foregroundColor(.secondary)
                    }
                    
                 
                } header: {
                    Text("About")
                }
                
                // Legal Section
                Section {
                    Link(destination: URL(string: "https://www.flashgen.app/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .foregroundColor(.primary)
                    }
                    Link(destination: URL(string: "https://www.flashgen.app/terms")!) {
                        Label("Terms of Use", systemImage: "doc.text.fill")
                            .foregroundColor(.primary)
                    }
                } header: {
                    Text("Legal")
                }
                
                // Feedback Section
                Section {
                    Link(destination: URL(string: "https://apps.apple.com/app/id123456789?action=write-review")!) {
                        Label("Rate this App", systemImage: "star.fill")
                            .foregroundColor(.primary)
                    }
                    Link(destination: URL(string: "mailto:support@flashgen.app")!) {
                        Label("Send Feedback", systemImage: "envelope.fill")
                            .foregroundColor(.primary)
                    }
                } header: {
                    Text("Feedback")
                }
                
                // Data Management Section (Only for Authenticated Users)
                if !authManager.isGuestMode {
                    Section {
                        Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                            HStack {
                                if viewModel.isDeleting {
                                    ProgressView()
                                } else {
                                    Image(systemName: "trash")
                                }
                                Text("Delete All Flashcard Sets")
                            }
                        }
                        .disabled(viewModel.isDeleting)
                        .alert("Delete All Data?", isPresented: $showDeleteConfirmation) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                Task {
                                    await viewModel.deleteAllSets()
                                }
                            }
                        } message: {
                            Text("This action cannot be undone. All your flashcard sets will be permanently deleted.")
                        }
                    } header: {
                        Text("Data Management")
                    }
                }
                
                // Sign Out / Sign In Section
                Section {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if authManager.isGuestMode {
                        Button(action: { showLoginSheet = true }) {
                            HStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                Text("Sign In / Create Account")
                            }
                        }
                    } else {
                        Button(role: .destructive, action: { Task { await viewModel.signOut(); await authManager.signOut() } }) {
                            HStack {
                                if viewModel.isSigningOut {
                                    ProgressView()
                                } else {
                                    Image(systemName: "door.left.hand.open")
                                }
                                Text("Sign Out")
                            }
                        }
                        .disabled(viewModel.isSigningOut)
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                if !authManager.isGuestMode {
                    await viewModel.loadUserProfile()
                }
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}

#Preview {
    SettingsView()
}
