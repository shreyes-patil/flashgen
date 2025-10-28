//
//  SupabaseFlashcardRepository.swift
//  FlashGen
//
//  Created by Shreyas Patil on 10/25/25.
//

import Foundation
import Supabase

final class SupabaseFlashcardRepository: FlashcardRepository {
    private let client: SupabaseClient
    
    private struct FlashcardSetDB: Codable {
        let id: String
        let user_id: String
        let title: String
        let difficulty: String
        let source_type: String?
        let source_url: String?
        let num_cards: Int
        let last_reviewed: String?
        let created_at: String
        let updated_at: String
    }
    
    private struct FlashcardDB: Codable {
        let id: String
        let set_id: String
        let question: String
        let answer: String
        let image_url: String?
        let created_at: String
        let updated_at: String
    }
    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func upsertSet(_ set: FlashcardSet) async throws {
        
        
        let dateFormatter = ISO8601DateFormatter()
        
        let setData = FlashcardSetDB(
            id: set.id,
            user_id: try await getCurrentUserId(),
            title: set.title,
            difficulty: set.difficulty.rawValue,
            source_type: set.sourceType.rawValue,
            source_url: set.sourceURL?.absoluteString,
            num_cards: set.cards.count,
            last_reviewed: dateFormatter.string(from: set.lastReviewed),
            created_at: dateFormatter.string(from: set.createdAt),
            updated_at: dateFormatter.string(from: set.updatedAt)
        )
        
        try await client.from("flashcard_sets")
            .upsert(setData)
            .execute()
        
        for card in set.cards {
            let cardData = FlashcardDB(
                id: card.id.uuidString,
                set_id: set.id,
                question: card.question,
                answer: card.answer,
                image_url: card.imageURL?.absoluteString,
                created_at: dateFormatter.string(from: Date()),
                updated_at: dateFormatter.string(from: Date())
            )
            
            try await client.from("flashcards")
                .upsert(cardData)
                .execute()
        }
    }
    
    func fetchSets() async throws -> [FlashcardSet] {
        // Fetch all sets for this user
        let response: [FlashcardSetDB] = try await client
            .from("flashcard_sets")
            .select()
            .eq("user_id", value: try await getCurrentUserId())
            .execute()
            .value
        
        let dateFormatter = ISO8601DateFormatter()
        
        // Convert each set
        var sets: [FlashcardSet] = []
        
        for setDB in response {
            // Fetch flashcards for this set
            let cardsResponse: [FlashcardDB] = try await client
                .from("flashcards")
                .select()
                .eq("set_id", value: setDB.id)
                .execute()
                .value
            
            // Convert flashcards
            let cards = cardsResponse.map { cardDB in
                Flashcard(
                    id: UUID(uuidString: cardDB.id) ?? UUID(),
                    question: cardDB.question,
                    answer: cardDB.answer,
                    imageURL: cardDB.image_url.flatMap { URL(string: $0) },
                    sourceCitation: nil,
                    hint: nil,
                    tags: nil
                )
            }
            
            // Create FlashcardSet
            let set = FlashcardSet(
                id: setDB.id,
                title: setDB.title,
                difficulty: FlashcardDifficulty(rawValue: setDB.difficulty) ?? .medium,
                cards: cards,
                createdAt: dateFormatter.date(from: setDB.created_at) ?? Date(),
                updatedAt: dateFormatter.date(from: setDB.updated_at) ?? Date(),
                lastReviewed: dateFormatter.date(from: setDB.last_reviewed ?? "just now bro") ?? Date(),
                sourceType: FlashcardSet.SourceType(rawValue: setDB.source_type ?? "") ?? .text,
                sourceURL: setDB.source_url.flatMap { URL(string: $0) },
                pdfPageRange: nil,
                notes: nil
            )
            print(" Loaded set: \(set.title) with \(set.cards.count) cards")
            sets.append(set)
        }
        
        return sets
    }
    
    func fetchSet(by id: String) async throws -> FlashcardSet? {
        return nil
    }
    
    func deleteSet(id: String) async throws {
        try await client.from("flashcard_sets")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    private func getCurrentUserId() async throws -> String {
        let session = try await client.auth.session
        return session.user.id.uuidString
    }
}
