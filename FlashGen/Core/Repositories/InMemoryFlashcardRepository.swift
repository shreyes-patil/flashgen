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
    
    func updateLastReviewed(setId: String) async throws {
        lock.lock(); defer { lock.unlock() }
        
        guard let set = storage[setId] else { return }
        
        var updatedSet = set
        updatedSet.lastReviewed = Date()
        
        storage[setId] = updatedSet
    }
    
    func deleteAllSets() async throws {
        lock.lock(); defer { lock.unlock() }
        storage.removeAll()
    }
    
    func clearLocalCache() async throws {
        try await deleteAllSets()
    }
}
