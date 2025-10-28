//
//  InMemoryFlashcardRepository.swift
//  FlashGen
//
//  Created by Shreyas Patil on 10/12/25.
//

import Foundation

final class InMemoryFlashcardRepository: FlashcardRepository {
 
    
    private var storage: [String: FlashcardSet] = [:]
    private let lock = NSLock()

    func upsertSet(_ set: FlashcardSet) async throws {
        lock.lock(); defer { lock.unlock() }
        storage[set.id] = set
    }
    func fetchSets() async throws -> [FlashcardSet] {
        lock.lock(); defer { lock.unlock() }
        return Array(storage.values).sorted { $0.updatedAt > $1.updatedAt }
    }
    func fetchSet(by id: String) async throws -> FlashcardSet? {
        lock.lock(); defer { lock.unlock() }
        return storage[id]
    }
    func deleteSet(id: String) async throws {
        lock.lock(); defer { lock.unlock() }
        storage.removeValue(forKey: id)
    }
}
