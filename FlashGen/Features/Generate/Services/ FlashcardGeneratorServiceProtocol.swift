//
//   FlashcardGeneratorServiceProtocol.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import Foundation


protocol FlashcardGeneratorServiceProtocol {
    func generateFlashcards(topic: String,
                            difficulty: FlashcardDifficulty,
                            count: Int) async throws -> [Flashcard]
}

enum FlashcardDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
