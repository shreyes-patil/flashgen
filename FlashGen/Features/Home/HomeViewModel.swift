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
        
        // 2. Fetch from remote (background sync)
        do {
            let remoteSets = try await repository.refreshSets()
            
            // Update UI with fresh data
            self.flashcardSets = remoteSets.filter { $0.cards.count > 0 }
            print("Refreshed \(flashcardSets.count) sets from Remote")
            flashcardSets.forEach { print("Fetched Set: \($0.title), ID: \($0.id)") }
        } catch let error as URLError where error.code == .cancelled {
            // Ignore cancellation errors
            print("Fetch cancelled")
        } catch {
            // Only show error if we have no data at all
            if flashcardSets.isEmpty {
                errorMessage = "Failed to load flashcard sets"
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
