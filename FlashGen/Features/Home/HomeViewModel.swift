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
    
    private let repository: FlashcardRepository = SupabaseFlashcardRepository()
    
    init() {
        // fetchSets will be called by the view
    }
    
    func fetchSets() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let allSets = try await repository.fetchSets()
                    
            flashcardSets = allSets.filter { $0.cards.count > 0 }
            print("Fetched \(flashcardSets.count) sets from Supabase")
        } catch {
            errorMessage = "Failed to load flashcard sets"
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
