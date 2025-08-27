//
//  MockFlashcardGenerationService.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import Foundation


struct MockFlashcardGenerationService: FlashcardGeneratorServiceProtocol {
    func generateFlashcards(topic: String, difficulty: FlashcardDifficulty, count: Int) async throws -> [Flashcard] {
        return (1...count).map { i in
            Flashcard(
                id: UUID(), question: "What is \(topic) - Q\(i)?", answer: "Answer \(i) for \(topic)"
            )
        }
    }
}
