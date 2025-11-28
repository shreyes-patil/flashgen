//
//  RealmFlashcardRepository.swift
//  FlashGen
//
//  Created by Shreyas Patil on 11/25/25.
//

import Foundation
import RealmSwift

final class RealmFlashcardRepository {
    
    init() throws {
        // No shared instance
    }
    
    func fetchSets() -> [FlashcardSet] {
        guard let realm = try? Realm() else { return [] }
        let realmSets = realm.objects(RealmFlashcardSet.self).sorted(byKeyPath: "createdAt", ascending: false)
        return realmSets.map { $0.toDomain() }
    }
    
    func saveSet(_ set: FlashcardSet) throws {
        let realm = try Realm()
        let realmSet = RealmFlashcardSet(from: set)
        try realm.write {
            realm.add(realmSet, update: .modified)
        }
    }
    
    func deleteSet(id: String) throws {
        let realm = try Realm()
        
        // Try to find the set by exact ID
        if let set = realm.object(ofType: RealmFlashcardSet.self, forPrimaryKey: id) {
            try realm.write {
                realm.delete(set.cards)
                realm.delete(set)
            }
        }
        
        // Also try to find by lowercased ID if different (handle duplicates cleanup)
        let lowerId = id.lowercased()
        if lowerId != id, let set = realm.object(ofType: RealmFlashcardSet.self, forPrimaryKey: lowerId) {
             try realm.write {
                realm.delete(set.cards)
                realm.delete(set)
            }
        }
        
        // Also try uppercased (for legacy cleanup)
        let upperId = id.uppercased()
        if upperId != id, let set = realm.object(ofType: RealmFlashcardSet.self, forPrimaryKey: upperId) {
             try realm.write {
                realm.delete(set.cards)
                realm.delete(set)
            }
        }
    }
    
    func updateLastReviewed(setId: String) throws {
        let realm = try Realm()
        if let set = realm.object(ofType: RealmFlashcardSet.self, forPrimaryKey: setId) {
            try realm.write {
                set.lastReviewed = Date()
            }
        }
    }
    
    func deleteAllSets() throws {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
    }
    
    func clearLocalCache() throws {
        try deleteAllSets()
    }
}
