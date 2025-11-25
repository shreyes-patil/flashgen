//
//  FlashcardsViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/14/25.
//

import Foundation
import Combine
import UIKit

final class FlashcardsViewModel: ObservableObject {
    @Published private(set) var cards : [Flashcard] = []
    @Published var currentIndex : Int = 0
    @Published var isRevealed : Bool = false
    
    init (cards : [Flashcard]) {
        self.cards = cards
    }
    
    var current : Flashcard? {
        cards.isEmpty ? nil : cards[currentIndex]
    }
    var progressText : String {
        "\(currentIndex+1)/\(cards.count)"
    }
    
    func flip(){
        isRevealed.toggle()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func next(){
        guard !cards.isEmpty else { return }
        currentIndex = min(currentIndex + 1, cards.count - 1)
        isRevealed = false
    }
    
    func previous(){
        guard !cards.isEmpty else { return }
        currentIndex = max(currentIndex - 1, 0)
        isRevealed = false
    }
    
    func peekNext() -> Flashcard? {
        guard currentIndex < cards.count - 1 else { return nil }
        return cards[currentIndex + 1]
    }
    
}
