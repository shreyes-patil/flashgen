//
//  SettingsView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI
import GoogleSignIn
import Supabase
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showDeleteConfirmation = false
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showLoginSheet = false
    @Environment(\.requestReview) var requestReview
    
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
                                Text(LocalizedStringKey("settings.guest.title"))
                                    .font(.headline)
                                Text(LocalizedStringKey("settings.guest.subtitle"))
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
                                .accessibilityLabel(Text(LocalizedStringKey("settings.profile_picture")))
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
                            Text(LocalizedStringKey("settings.loading_profile"))
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text(LocalizedStringKey("settings.account.header"))
                }
                
                // App Info Section
                Section {
                    HStack {
                        Text(LocalizedStringKey("settings.version"))
                        Spacer()
                        Text(viewModel.appVersion)
                            .foregroundColor(.secondary)
                    }
                    
                 
                } header: {
                    Text(LocalizedStringKey("settings.about.header"))
                }
                
                // Legal Section
                Section {
                    Link(destination: URL(string: "https://flashgen-web.vercel.app/privacy")!) {
                        Label(LocalizedStringKey("settings.privacy"), systemImage: "hand.raised.fill")
                            .foregroundColor(.primary)
                    }
                    Link(destination: URL(string: "https://flashgen-web.vercel.app/terms")!) {
                        Label(LocalizedStringKey("settings.terms"), systemImage: "doc.text.fill")
                            .foregroundColor(.primary)
                    }
                } header: {
                    Text(LocalizedStringKey("settings.legal.header"))
                }
                
                // Feedback Section
                Section {
                    Button(action: {
                        requestReview()
                    }) {
                        Label(LocalizedStringKey("settings.rate_app"), systemImage: "star.fill")
                            .foregroundColor(.primary)
                    }
                    Link(destination: URL(string: "mailto:shreyas.patil0602@gmail.com")!) {
                        Label(LocalizedStringKey("settings.send_feedback"), systemImage: "envelope.fill")
                            .foregroundColor(.primary)
                    }
                } header: {
                    Text(LocalizedStringKey("settings.feedback.header"))
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
                                Text(LocalizedStringKey("settings.signin_create"))
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
                                Text(LocalizedStringKey("settings.signout"))
                            }
                        }
                        .disabled(viewModel.isSigningOut)
                    }
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
                                Text(LocalizedStringKey("settings.delete_all"))
                            }
                        }
                        .disabled(viewModel.isDeleting)
                        .alert(LocalizedStringKey("settings.delete_all.alert.title"), isPresented: $showDeleteConfirmation) {
                            Button(LocalizedStringKey("cancel"), role: .cancel) { }
                            Button(LocalizedStringKey("delete"), role: .destructive) {
                                Task {
                                    await viewModel.deleteAllSets()
                                }
                            }
                        } message: {
                            Text(LocalizedStringKey("settings.delete_all.alert.message"))
                        }
                    } header: {
                        Text(LocalizedStringKey("settings.data.header"))
                    }
                }
            }
            .navigationTitle(Text(LocalizedStringKey("settings.title")))
            .task {
                if !authManager.isGuestMode {
                    await viewModel.loadUserProfile()
                }
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView()
                    .environmentObject(authManager)
            }
            .onChange(of: authManager.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    Task {
                        await viewModel.loadUserProfile()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
