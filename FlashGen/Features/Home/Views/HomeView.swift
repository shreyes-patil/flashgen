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
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]

    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack {
                Text(LocalizedStringKey("saved_flashcard_sets_title"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Menu {
                    Picker(LocalizedStringKey("sort_by"), selection: $viewModel.sortOption) {
                        Label(LocalizedStringKey("sort_date_created"), systemImage: "calendar").tag(HomeViewModel.SortOption.createdNewest)
                        Label(LocalizedStringKey("sort_last_reviewed"), systemImage: "clock").tag(HomeViewModel.SortOption.lastReviewed)
                        Label(LocalizedStringKey("sort_alphabetical"), systemImage: "textformat").tag(HomeViewModel.SortOption.alphabetical)
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .imageScale(.large)
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
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
                            ForEach(viewModel.sortedSets) { set in
                                // Deterministic color based on ID hash
                                let colorIndex = abs(set.id.stableHash) % Color.cardPalette.count
                                let backgroundColor = Color.cardPalette[colorIndex]
                                
                                FlashcardSetGridItem(set: set, backgroundColor: backgroundColor)
                                    .environmentObject(viewModel)
                            }
                        }
                        .padding()
                    }
                }
                .accessibilityLabel(Text(LocalizedStringKey("saved_flashcard_sets_list_accessibility_label")))
                .refreshable {
                    await viewModel.fetchSets()
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
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchSets()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.fetchSets()
                }
            }
        }
    }
}
private struct FlashcardSetGridItem: View {
    let set: FlashcardSet
    let backgroundColor : Color
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showDeleteAlert = false

    
    
    private var lastReviewedText: String {
        self.set.lastReviewed.relativeFormattedString(style: .short)
            ?? NSLocalizedString("never", comment: "Never reviewed")
    }

    private var accessibilitySummary: String {
        let cardsString = String.localizedStringWithFormat(NSLocalizedString("%d flashcards", comment: ""), set.cards.count)
        let reviewedString = String(format: NSLocalizedString("Last reviewed %@", comment: ""), lastReviewedText)
        return "\(set.title), \(cardsString), \(reviewedString)"
    }

    var body: some View {
        NavigationLink {
            FlashcardSetView(
                flashcardSetTitle: set.title,
                flashcards: set.cards,
                lastReviewed: lastReviewedText,
                numberOfCards: set.cards.count,
                difficulty: set.difficulty, isSavedInitial: true,
                setId: set.id,
                color: backgroundColor
            )
        } label: {
            FlashcardSetTileView(set: set, backgroundColor : backgroundColor)
                .accessibilityLabel(accessibilitySummary)
                .accessibilityAddTraits(.isButton)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label(LocalizedStringKey("delete_set_button"), systemImage: "trash")
            }
            .accessibilityLabel(Text(LocalizedStringKey("delete_set_accessibility_label")))
            .accessibilityHint(Text(LocalizedStringKey("delete_set_accessibility_hint")))
        }
        .alert(LocalizedStringKey("delete_set_alert_title"), isPresented: $showDeleteAlert) {
            Button(LocalizedStringKey("cancel"), role: .cancel) { }
            Button(LocalizedStringKey("delete"), role: .destructive) {
                Task {
                    await viewModel.deleteSet(set)
                }
            }
        } message: {
            Text(LocalizedStringKey("delete_set_alert_message"))
        }
    }
}

