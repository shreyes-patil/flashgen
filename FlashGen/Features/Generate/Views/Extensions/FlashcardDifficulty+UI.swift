//
//  FlashcardDifficulty+UI.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/28/25.
//

import SwiftUI

extension FlashcardDifficulty {
    var displayName: LocalizedStringKey {
        switch self {
        case .easy: return "difficulty_easy"
        case .medium: return "difficulty_medium"
        case .hard: return "difficulty_hard"
        }
    }
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .red
        }
    }
}
