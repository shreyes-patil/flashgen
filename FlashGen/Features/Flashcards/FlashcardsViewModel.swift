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
    @Published private(set) var currentIndex : Int = 0
    @Published var isRevealed : Bool = false
    @Published var isPaging : Bool = false
    
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
        guard !isPaging else { return }
        isRevealed.toggle()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func next(){
        guard !cards.isEmpty, !isPaging else { return }
        isPaging = true
        defer {isPaging = false}
        currentIndex = min(currentIndex + 1, cards.count - 1)
        isRevealed = false
    }
    
    func previous(){
        guard !cards.isEmpty, !isPaging else { return }
        isPaging = true
        defer {isPaging = false}
        currentIndex = max(currentIndex - 1, 0)
        isRevealed = false
    }
    
    
}
