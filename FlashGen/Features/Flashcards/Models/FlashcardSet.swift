//
//  Flashcard.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/16/25.
//

import Foundation


struct FlashcardSet: Identifiable, Codable {
    let id: String
    var title: String
    var difficulty: FlashcardDifficulty
    var cards: [Flashcard]
    var createdAt: Date
    var updatedAt: Date
    var lastReviewed : Date
    enum SourceType: String, Codable, Hashable { case text, image, pdf, url }
    var sourceType: SourceType
    var sourceURL: URL?
    var pdfPageRange: String?
    var notes: String?
}

extension FlashcardSet: Equatable {
    static func == (lhs: FlashcardSet, rhs: FlashcardSet) -> Bool { lhs.id == rhs.id }
}
extension FlashcardSet: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
