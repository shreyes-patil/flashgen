//
//  Flashcard.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import Foundation

struct Flashcard: Identifiable, Codable {
    let id: UUID
    var question: String
    var answer: String

    var imageURL: URL?
    var sourceCitation: String?
    var hint: String?
    var tags: [String]?
}

extension Flashcard: Equatable {
    static func == (lhs: Flashcard, rhs: Flashcard) -> Bool { lhs.id == rhs.id }
}
extension Flashcard: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
