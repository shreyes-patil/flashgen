//
//  RealmModels.swift
//  FlashGen
//
//  Created by Shreyas Patil on 11/25/25.
//

import Foundation
import RealmSwift

class RealmFlashcardSet: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var difficultyRaw: String
    @Persisted var createdAt: Date
    @Persisted var updatedAt: Date
    @Persisted var lastReviewed: Date
    @Persisted var sourceTypeRaw: String
    @Persisted var sourceURL: String?
    @Persisted var cards: List<RealmFlashcard>
    
    // Computed properties for enums
    var difficulty: FlashcardDifficulty {
        get { FlashcardDifficulty(rawValue: difficultyRaw) ?? .medium }
        set { difficultyRaw = newValue.rawValue }
    }
    
    var sourceType: FlashcardSet.SourceType {
        get { FlashcardSet.SourceType(rawValue: sourceTypeRaw) ?? .text }
        set { sourceTypeRaw = newValue.rawValue }
    }
    
    convenience init(from set: FlashcardSet) {
        self.init()
        self.id = set.id.lowercased() // Normalize to lowercase to match Supabase
        self.title = set.title
        self.difficultyRaw = set.difficulty.rawValue
        self.createdAt = set.createdAt
        self.updatedAt = set.updatedAt
        self.lastReviewed = set.lastReviewed
        self.sourceTypeRaw = set.sourceType.rawValue
        self.sourceURL = set.sourceURL?.absoluteString
        
        let realmCards = set.cards.map { RealmFlashcard(from: $0) }
        self.cards.append(objectsIn: realmCards)
    }
    
    func toDomain() -> FlashcardSet {
        return FlashcardSet(
            id: id,
            title: title,
            difficulty: difficulty,
            cards: cards.map { $0.toDomain() },
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastReviewed: lastReviewed,
            sourceType: sourceType,
            sourceURL: sourceURL.flatMap { URL(string: $0) },
            pdfPageRange: nil, // Not persisting this for now or add if needed
            notes: nil // Not persisting this for now
        )
    }
}

class RealmFlashcard: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var question: String
    @Persisted var answer: String
    @Persisted var imageURL: String?
    
    convenience init(from card: Flashcard) {
        self.init()
        self.id = card.id.uuidString
        self.question = card.question
        self.answer = card.answer
        self.imageURL = card.imageURL?.absoluteString
    }
    
    func toDomain() -> Flashcard {
        return Flashcard(
            id: UUID(uuidString: id) ?? UUID(),
            question: question,
            answer: answer,
            imageURL: imageURL.flatMap { URL(string: $0) },
            sourceCitation: nil,
            hint: nil,
            tags: nil
        )
    }
}
