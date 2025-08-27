//
//   FlashcardGeneratorServiceProtocol.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import Foundation
import SwiftUI

protocol FlashcardGeneratorServiceProtocol {
    func generateFlashcards(topic: String,
                            difficulty: FlashcardDifficulty,
                            count: Int) async throws -> [Flashcard]
}


extension FlashcardDifficulty {
    var displayName : LocalizedStringKey{
        switch self {
        case .easy :
            return "difficulty_easy"
        case .medium :
            return "difficulty_medium"
        case .hard :
            return "difficulty_hard"
        }
        
    }
    
}
