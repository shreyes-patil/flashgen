//
//  Flashcard.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import Foundation

struct Flashcard: Identifiable {
    let id : UUID
    let question : String
    let answer : String
}
