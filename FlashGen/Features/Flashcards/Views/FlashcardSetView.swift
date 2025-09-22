//
//  FlashcardSetView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import SwiftUI

struct FlashcardSetView: View {
    let flashcardSetTitle : String
    let flashcards : [Flashcard]
    let lastReviewed: String
    let numberOfCards: Int
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            VStack{
                FlashcardSetHeaderView(title: flashcardSetTitle, numberOfCards: numberOfCards, lastReviewed: lastReviewed)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    .padding(.top, 8)
                    .padding()
                    .padding(.bottom, 50)
                
                ScrollView{
                    FlashcardListView(flashcards: flashcards)
                        .padding()
                        .padding(.bottom, 100)
                }
                
                .safeAreaInset(edge: .bottom) {
                    NavigationLink {
                        FlashcardDeckView(vm: .init(cards: flashcards))   // push the deck
                    } label: {
                        Text(LocalizedStringKey("start_practicing"))
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight]))
                            .shadow(radius: 4)
                            .padding(.horizontal, 2)
                    }
                    .buttonStyle(.plain) // preserves your custom background
                    .accessibilityLabel(Text("Start practicing"))
                    .accessibilityHint(Text("Begin going through the flashcards in this set"))
                }
                
            }
            .navigationBarTitle(Text(String.localizedStringWithFormat(NSLocalizedString("flashcard_set_title", comment: "Flashcard Set Screen Title"), flashcardSetTitle)))
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    FlashcardSetView(
            flashcardSetTitle: "Calculus Formulas",
            flashcards: [
                Flashcard(id: UUID(), question: "What is derivative of x²?", answer: "2x"),
                Flashcard(id: UUID(), question: "What is ∫1/x dx?", answer: "ln|x| + C"),
                Flashcard(id: UUID(), question: "What is limit of sin(x)/x?", answer: "1"),
                Flashcard(id: UUID(), question: "What is d/dx of e^x?", answer: "e^x"),
                Flashcard(id: UUID(), question: "What is the derivative of ln(x)?", answer: "1/x"),
                Flashcard(id: UUID(), question: "What is the derivative of sin(x)?", answer: "cos(x)"),
                Flashcard(id: UUID(), question: "What is the derivative of cos(x)?", answer: "-sin(x)"),
                Flashcard(id: UUID(), question: "What is the integral of cos(x)?", answer: "sin(x) + C"),
                Flashcard(id: UUID(), question: "What is the integral of sin(x)?", answer: "-cos(x) + C"),
                Flashcard(id: UUID(), question: "What is the second derivative of x³?", answer: "6x"),
                Flashcard(id: UUID(), question: "What is the derivative of tan(x)?", answer: "sec²(x)"),
                Flashcard(id: UUID(), question: "What is the integral of sec²(x)?", answer: "tan(x) + C"),
                Flashcard(id: UUID(), question: "What is d/dx of ln|x|?", answer: "1/x"),
                Flashcard(id: UUID(), question: "What is the limit of (1 + 1/n)^n as n → ∞?", answer: "e"),
                Flashcard(id: UUID(), question: "What is d/dx of a^x (a > 0)?", answer: "a^x * ln(a)"),
                Flashcard(id: UUID(), question: "What is the limit of (e^x - 1)/x as x → 0?", answer: "1")

            ],
            lastReviewed: "2 days ago",
          
            numberOfCards: 20
        )
}
