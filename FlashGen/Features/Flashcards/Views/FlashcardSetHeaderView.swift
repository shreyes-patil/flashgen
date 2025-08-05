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
            RoundedLabel(text: lastReviewed, color: .red)
                .rotationEffect(.degrees(4))
                .offset(x: 30, y: 60)
                .zIndex(0)
                
            RoundedLabel(text: "\(numberOfCards) flashcards", color: .pink)
                .zIndex(1)
                .rotationEffect(.degrees(-5))
                .offset(x: -40, y: 20)
            
            RoundedLabel(text: title, color: .green)
                .zIndex(2)
                .offset(x: 30, y: -20)
                .rotationEffect(.degrees(4))
        }
        .frame(maxWidth : .infinity, alignment: .center)
    }
}
#Preview {
    FlashcardSetHeaderView(
        title: "Calculus Formulas",
        numberOfCards: 20,
        lastReviewed: "2 days ago"
    )
}


