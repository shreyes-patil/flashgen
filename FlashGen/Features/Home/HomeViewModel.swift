//
//  HomeViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var flashcardSets : [FlashcardSet] = []
    
    init(){
        loadMockData()
    }
    
    private func loadMockData(){
        flashcardSets = [
            FlashcardSet(title: "mitochondria", numberofCards: 12, lastReviewed: .now, icon: "heart.text.clipboard.fill", flashcards: [
                Flashcard(id: UUID(), question: "What is the main function of mitochondria?", answer: "Producing energy in the form of ATP"),
                Flashcard(id: UUID(), question: "What process occurs in the mitochondria?", answer: "Cellular respiration"),
                Flashcard(id: UUID(), question: "Why is mitochondria called the powerhouse of the cell?", answer: "Because it generates most of the cell's energy")
            ]
),
            FlashcardSet(title: "Egypt History", numberofCards: 10, lastReviewed: .now.addingTimeInterval(-3600), icon: "book.pages.fill", flashcards: [
                Flashcard(id: UUID(), question: "Who was the first pharaoh of Egypt?", answer: "Narmer (also known as Menes)"),
                Flashcard(id: UUID(), question: "What is the writing system of ancient Egypt called?", answer: "Hieroglyphics"),
                Flashcard(id: UUID(), question: "Which river was essential to ancient Egyptian civilization?", answer: "The Nile River")
            ]
),
            FlashcardSet(title: "Calculus formulas", numberofCards: 20, lastReviewed: .now.addingTimeInterval(-7200), icon: "equal.circle.fill", flashcards:[
                Flashcard(id: UUID(), question: "What is the derivative of x²?", answer: "2x"),
                Flashcard(id: UUID(), question: "What is ∫1/x dx?", answer: "ln|x| + C"),
                Flashcard(id: UUID(), question: "What is the limit of sin(x)/x as x → 0?", answer: "1"),
                Flashcard(id: UUID(), question: "What is d/dx of e^x?", answer: "e^x"),
                Flashcard(id: UUID(), question: "What is d/dx of ln(x)?", answer: "1/x"),
                Flashcard(id: UUID(), question: "What is d/dx of sin(x)?", answer: "cos(x)"),
                Flashcard(id: UUID(), question: "What is d/dx of cos(x)?", answer: "-sin(x)"),
                Flashcard(id: UUID(), question: "What is ∫cos(x) dx?", answer: "sin(x) + C"),
                Flashcard(id: UUID(), question: "What is ∫sin(x) dx?", answer: "-cos(x) + C"),
                Flashcard(id: UUID(), question: "What is the second derivative of x³?", answer: "6x"),
                Flashcard(id: UUID(), question: "What is d/dx of tan(x)?", answer: "sec²(x)"),
                Flashcard(id: UUID(), question: "What is ∫sec²(x) dx?", answer: "tan(x) + C"),
                Flashcard(id: UUID(), question: "What is the limit of (1 + 1/n)^n as n → ∞?", answer: "e"),
                Flashcard(id: UUID(), question: "What is d/dx of a^x?", answer: "a^x · ln(a)"),
                Flashcard(id: UUID(), question: "What is the limit of (e^x - 1)/x as x → 0?", answer: "1")
            ]
)
        ]
    }
}
