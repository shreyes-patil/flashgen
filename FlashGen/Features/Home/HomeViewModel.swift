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
    
    private let repository: FlashcardRepository = SupabaseFlashcardRepository()
    
    init() {
        Task {
            await fetchSets()
        }
    }
    
    func fetchSets() async {
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
}
