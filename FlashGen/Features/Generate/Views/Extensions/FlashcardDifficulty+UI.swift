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
    
    var localizedName: String {
        switch self {
        case .easy: return NSLocalizedString("difficulty_easy", comment: "Easy difficulty")
        case .medium: return NSLocalizedString("difficulty_medium", comment: "Medium difficulty")
        case .hard: return NSLocalizedString("difficulty_hard", comment: "Hard difficulty")
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
