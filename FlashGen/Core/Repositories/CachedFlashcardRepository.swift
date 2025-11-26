//
//  CachedFlashcardRepository.swift
//  FlashGen
//
//  Created by Shreyas Patil on 11/25/25.
//

import Foundation

final class CachedFlashcardRepository: FlashcardRepository {
    private let local: RealmFlashcardRepository
    private let remote: RemoteFlashcardRepository
    
    init() {
        do {
            self.local = try RealmFlashcardRepository()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
        self.remote = RemoteFlashcardRepository()
    }
    
    func fetchSets() async throws -> [FlashcardSet] {
        // 1. Fetch from local cache immediately
        let localSets = local.fetchSets()
        
        // 2. Return local sets if available (to show UI immediately)
        // Note: This function signature returns [FlashcardSet], so we can't "stream" updates easily here.
        // We will return local sets first, but the ViewModel needs to handle the background refresh.
        // However, standard async/await returns once.
        // Strategy: We will return local sets here if we want "offline first".
        // But to get "fresh" data, we usually want to fetch remote.
        //
        // Better Strategy for ViewModel:
        // ViewModel calls `fetchLocalSets()` -> updates UI
        // ViewModel calls `refreshSets()` -> fetches remote, saves to local, updates UI
        
        // For now, let's make this return local sets if available, but trigger a background refresh?
        // No, `fetchSets` is usually expected to return the "source of truth".
        // If we return local, we are fast.
        
        if !localSets.isEmpty {
            return localSets
        }
        
        // If local is empty, try remote
        let remoteSets = try await remote.fetchSets()
        
        // Save to local
        for set in remoteSets {
            try? local.saveSet(set)
        }
        
        return remoteSets
    }
    
    // New method to force refresh from remote
    func refreshSets() async throws -> [FlashcardSet] {
        let remoteSets = try await remote.fetchSets()
        
        // Update local cache
        // Ideally we should sync deletions too, but for now let's just upsert
        for set in remoteSets {
            try? local.saveSet(set)
        }
        
        return remoteSets
    }
    
    // Expose local fetch for ViewModel to use directly
    func fetchLocalSets() -> [FlashcardSet] {
        return local.fetchSets()
    }
    
    func upsertSet(_ set: FlashcardSet) async throws {
        // 1. Save to local immediately
        try? local.saveSet(set)
        
        // 2. Save to remote
        try await remote.upsertSet(set)
    }
    
    func deleteSet(id: String) async throws {
        // 1. Delete from local
        try? local.deleteSet(id: id)
        
        // 2. Delete from remote
        try await remote.deleteSet(id: id)
    }
    
    func updateLastReviewed(setId: String) async throws {
        // 1. Update local
        try? local.updateLastReviewed(setId: setId)
        
        // 2. Update remote
        try await remote.updateLastReviewed(setId: setId)
    }
    
    func fetchSet(by id: String) async throws -> FlashcardSet? {
        // Not implemented in remote yet, but could check local first
        return nil
    }
    
    func deleteAllSets() async throws {
        // 1. Delete from local
        try? local.deleteAllSets()
        
        // 2. Delete from remote
        try await remote.deleteAllSets()
    }
}
