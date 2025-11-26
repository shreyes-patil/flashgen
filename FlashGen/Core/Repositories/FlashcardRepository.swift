//
//  FlashcardRepository.swift
//  FlashGen
//
//  Created by Shreyas Patil on 10/12/25.
//

import Foundation


protocol FlashcardRepository {
    func upsertSet(_ set : FlashcardSet) async throws
    func fetchSets() async throws -> [FlashcardSet]
    func fetchSet(by id : String) async throws -> FlashcardSet?
    func deleteSet(id : String) async throws
    func updateLastReviewed(setId: String) async throws
    func deleteAllSets() async throws
}
