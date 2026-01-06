//
//  HomeViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var flashcardSets: [FlashcardSet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    enum SortOption {
        case createdNewest
        case lastReviewed
        case alphabetical
    }
    
    @Published var sortOption: SortOption = .createdNewest
    
    var sortedSets: [FlashcardSet] {
        switch sortOption {
        case .createdNewest:
            return flashcardSets.sorted { $0.createdAt > $1.createdAt }
        case .lastReviewed:
            return flashcardSets.sorted { $0.lastReviewed > $1.lastReviewed }
        case .alphabetical:
            return flashcardSets.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }
    
    private let repository = CachedFlashcardRepository()
    
    init() {
        // fetchSets will be called by the view
    }
    
    func fetchSets() async {
        // 1. Load from local cache immediately
        let localSets = repository.fetchLocalSets()
        if !localSets.isEmpty {
            self.flashcardSets = localSets.filter { $0.cards.count > 0 }
            // Don't set isLoading to true if we have data
        } else {
            isLoading = true
        }
        
        errorMessage = nil
        
        // Check for "What's New" update
        if let whatsNewSet = WhatsNewService.shared.checkForUpdates() {
            // Save locally immediately
            do {
                try await repository.upsertSet(whatsNewSet)
                // We'll let the local fetch below pick it up or append it
                // But since we fetch local sets *before* this, we might need to append it manually
                // or just rely on the next refresh.
                // Let's append it to current sets if not present
                if !flashcardSets.contains(where: { $0.id == whatsNewSet.id }) {
                    flashcardSets.insert(whatsNewSet, at: 0)
                }
            } catch {
                print("Failed to save What's New set: \(error)")
            }
        }
        
        // 2. Fetch from remote (background sync)
        do {
            let remoteSets = try await repository.refreshSets()
            
            // Update UI with fresh data
            // Maintain local-only sets (like What's New)
            let currentLocalOnlySets = self.flashcardSets.filter { set in
                // Assume any set not in remoteSets but is WhatsNew is local-only
                if WhatsNewService.shared.isWhatsNewSet(id: set.id) {
                    return true
                }
                return false
            }
            
            var combinedSets = remoteSets
            
            // Re-insert What's New set if it was there
            for localSet in currentLocalOnlySets {
                if !combinedSets.contains(where: { $0.id == localSet.id }) {
                    combinedSets.insert(localSet, at: 0)
                }
            }
            
            self.flashcardSets = combinedSets.filter { $0.cards.count > 0 }
            print("Refreshed \(flashcardSets.count) sets from Remote (preserving local sets)")
            flashcardSets.forEach { print("Fetched Set: \($0.title), ID: \($0.id)") }
        } catch let error as URLError where error.code == .cancelled {
            // Ignore cancellation errors
            print("Fetch cancelled")
        } catch {
            // Only show error if we have no data at all
            if flashcardSets.isEmpty {
                errorMessage = NSLocalizedString("home.error.load_failed", comment: "")
            }
            print("Fetch error: \(error)")
        }
        
        isLoading = false
    }
    
    func deleteSet(_ set: FlashcardSet) async {
        do {
            try await repository.deleteSet(id: set.id)
            
            await MainActor.run {
                flashcardSets.removeAll { $0.id == set.id }
            }
            
            print("Deleted set: \(set.title)")
        } catch {
            print("Delete error: \(error)")
        }
    }
}
