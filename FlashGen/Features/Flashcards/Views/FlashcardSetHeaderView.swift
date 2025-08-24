//
//  FlashcardSetHeaderView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/3/25.
//

import SwiftUI

struct FlashcardSetHeaderView: View {
    let title : String
    let numberOfCards : Int
    let lastReviewed : String
    
    var body: some View {
        ZStack{
            RoundedLabel(text: String.localizedStringWithFormat(NSLocalizedString("Last reviewed: %@", comment: "Last reviewed date"),lastReviewed), color: .red)
                .rotationEffect(.degrees(4))
                .offset(x: 30, y: 60)
                .zIndex(0)
                .accessibilityHidden(true)
            
            RoundedLabel(text: String.localizedStringWithFormat(NSLocalizedString("%d flashcards",comment: "Number of flashcards"),numberOfCards), color: .pink)
                .zIndex(1)
                .rotationEffect(.degrees(-5))
                .offset(x: -40, y: 20)
                .accessibilityHidden(true)
            
            RoundedLabel(text: title, color: .green)
                .zIndex(2)
                .offset(x: 30, y: -20)
                .rotationEffect(.degrees(4))
                .accessibilityHidden(true)
        }
        .frame(maxWidth : .infinity, alignment: .center)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(title). \(numberOfCards) flashcards. Last reviewed: \(lastReviewed)"))
    }
}
#Preview {
    FlashcardSetHeaderView(
        title: "Calculus Formulas",
        numberOfCards: 20,
        lastReviewed: "2 days ago"
    )
}


