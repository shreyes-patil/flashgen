//
//  FlashcardListView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import SwiftUI

struct FlashcardListView: View {
    let flashcards: [Flashcard]
    var color: Color = .yellow
    let onFlashcardTap: ((Flashcard) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(flashcards) { card in
                FlashcardRowView(card: card, color: color, onTap: onFlashcardTap)
            }
        }
    }
}

//#Preview {
//    FlashcardListView()
//}
