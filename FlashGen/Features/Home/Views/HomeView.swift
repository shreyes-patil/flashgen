//
//  HomeView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var isLoading: Bool = false
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if viewModel.flashcardSets.isEmpty {
                        if !isLoading {
                            VStack(spacing: 12) {
                                Image(systemName: "rectangle.stack.badge.plus")
                                    .imageScale(.large)
                                    .font(.system(size: 40, weight: .regular))
                                    .foregroundStyle(.secondary)
                                    .accessibilityHidden(true)
                                Text(LocalizedStringKey("empty_sets_title"))
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Text(LocalizedStringKey("empty_sets_subtitle"))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .accessibilityLabel(Text(LocalizedStringKey("empty_sets_accessibility_hint")))
                                Button(action: { Task { await viewModel.fetchSets() } }) {
                                    Text(LocalizedStringKey("retry_button_title"))
                                }
                                .buttonStyle(.borderedProminent)
                                .accessibilityLabel(Text(LocalizedStringKey("retry_button_accessibility_label")))
                                .accessibilityHint(Text(LocalizedStringKey("retry_button_accessibility_hint")))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.flashcardSets) { set in
                                FlashcardSetGridItem(set: set)
                            }
                        }
                        .padding()
                    }
                }
                .accessibilityLabel(Text(LocalizedStringKey("saved_flashcard_sets_list_accessibility_label")))
                .refreshable {
                    isLoading = true
                    await viewModel.fetchSets()
                    isLoading = false
                }

                if isLoading && viewModel.flashcardSets.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView(LocalizedStringKey("loading_sets_progress_title"))
                            .progressViewStyle(.circular)
                            .controlSize(.large)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear.accessibilityHidden(true))
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel(Text(LocalizedStringKey("loading_sets_accessibility_label")))
                }
            }
            .navigationTitle(LocalizedStringKey("saved_flashcard_sets_title"))
            .onAppear {
                Task {
                    isLoading = true
                    await viewModel.fetchSets()
                    isLoading = false
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    Task {
                        isLoading = true
                        await viewModel.fetchSets()
                        isLoading = false
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .flashcardSetsDidChange)) { _ in
                Task {
                    isLoading = true
                    await viewModel.fetchSets()
                    isLoading = false
                }
            }
        }
        
        
    }
    
}


private struct FlashcardSetGridItem: View {
    let set: FlashcardSet

    private var lastReviewedText: String {
        self.set.lastReviewed.relativeFormattedString(style: .short)
            ?? NSLocalizedString("Never", comment: "")
        }

    private var accessibilitySummary: String {
        "\(set.title), \(set.cards.count) cards, last reviewed: \(lastReviewedText)"
    }

    var body: some View {
        NavigationLink {
            FlashcardSetView(
                flashcardSetTitle: set.title,
                flashcards: set.cards,
                lastReviewed: lastReviewedText,
                numberOfCards: set.cards.count,
                isSavedInitial: true
            )
        } label: {
            FlashcardSetTileView(set: set)
                .accessibilityLabel(accessibilitySummary)
                .accessibilityAddTraits(.isButton)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

