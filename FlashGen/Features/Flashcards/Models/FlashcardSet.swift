//
//  Flashcard.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/16/25.
//

import Foundation


struct FlashcardSet: Identifiable {
    let id =  UUID()
    let title: String
    let numberofCards: Int
    let lastReviewed: Date
    let icon: String
    let flashcards : [Flashcard]
}
