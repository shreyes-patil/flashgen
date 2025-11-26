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
    
    var body: some View {
        NavigationStack {
            Form {
                // User Profile Section
                Section {
                    if let user = viewModel.user {
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
                
                // Data Management Section
                Section {
                    Button(role: .destructive, action: { showDeleteConfirmation = true }) {
                        HStack {
                            if viewModel.isDeleting {
                                ProgressView()
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
                
                // Sign Out Section
                Section {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(role: .destructive, action: { Task { await viewModel.signOut() } }) {
                        HStack {
                            if viewModel.isSigningOut {
                                ProgressView()
                            }
                            Text("Sign Out")
                        }
                    }
                    .disabled(viewModel.isSigningOut)
                }
            }
            .navigationTitle("Settings")
            .task {
                await viewModel.loadUserProfile()
            }
        }
    }
}

#Preview {
    SettingsView()
}
