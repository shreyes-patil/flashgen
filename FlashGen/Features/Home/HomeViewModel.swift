//
//  HomeViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var flashcardSets : [FlashcardSet] = []
    
    init(){
        loadMockData()
    }
    
    private func loadMockData(){
        flashcardSets = [
            FlashcardSet(name: "mitochondria", numberofCards: 12, lastReviewed: .now, icon: "heart.text.clipboard.fill"),
            FlashcardSet(name: "Egypt History", numberofCards: 10, lastReviewed: .now.addingTimeInterval(-3600), icon: "book.pages.fill"),
            FlashcardSet(name: "Calculus formulas", numberofCards: 20, lastReviewed: .now.addingTimeInterval(-7200), icon: "equal.circle.fill")
        ]
    }
}
