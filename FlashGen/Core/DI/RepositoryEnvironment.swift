//
//  FlashcardDI.swift
//  FlashGen
//
//  Created by Shreyas Patil on 10/12/25.
//

import Foundation
import SwiftUI

struct FlashcardRepositoryKey: EnvironmentKey{
    static var defaultValue: any FlashcardRepository = UnimplementedRepo()
}


extension EnvironmentValues{
    var flashcardRepository: any FlashcardRepository{
        get{
            self[FlashcardRepositoryKey]
        }set{
            self[FlashcardRepositoryKey] = newValue
        }
    }
}

final class UnimplementedRepo: FlashcardRepository{
    func upsertSet(_ set: FlashcardSet) async throws {
        fatalError("repo not injected")
    }
    func fetchSets() async throws -> [FlashcardSet] {
        fatalError("repo not injected")
    }
    func fetchSet(by id: String) async throws -> FlashcardSet? {
        fatalError("repo not injected")
    }
    func deleteSet( id: String) async throws {
        fatalError("repo not injected")
    }
}
