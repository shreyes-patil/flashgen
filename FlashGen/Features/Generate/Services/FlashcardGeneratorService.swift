//
//  FlashcardGeneratorService.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import Foundation

final class FlashcardGeneratorService: FlashcardGeneratorServiceProtocol {
    
    func generateFlashcards(topic: String, difficulty: FlashcardDifficulty, count: Int) async throws -> [Flashcard] {
        let response = try await NetworkManager.shared.generateFlashcards(
            topic: topic,
            count: count,
            difficulty: difficulty.rawValue
        )
        
        return response.data.flashcards.map { generatedCard in
            Flashcard(
                id: UUID(),
                question: generatedCard.question,
                answer: generatedCard.answer,
                imageURL: nil,
                sourceCitation: generatedCard.source,
                hint: nil,
                tags: generatedCard.tags
            )
        }
    }
}
