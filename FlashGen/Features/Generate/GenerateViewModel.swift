//
//  GenerateViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import Foundation
import UIKit

@MainActor
final class GenerateViewModel: ObservableObject {
    @Published var topic : String = ""
    @Published var difficulty : FlashcardDifficulty = .easy
    @Published var numberOfCards : Int = 10
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    @Published var flashcards : [Flashcard] = []
    @Published var generatedSetId: String = ""
    
    private let service : FlashcardGeneratorServiceProtocol
    
    init(service: FlashcardGeneratorServiceProtocol){
        self.service = service
    }
    
    func generate() async{
        guard !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = GenerateFlashcardsError.emptyTopic.localizedDescription
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        var bgTaskID: UIBackgroundTaskIdentifier = .invalid
        bgTaskID = UIApplication.shared.beginBackgroundTask(withName: "GenerateFlashcards") {
            UIApplication.shared.endBackgroundTask(bgTaskID)
            bgTaskID = .invalid
        }
        
        defer {
            if bgTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(bgTaskID)
                bgTaskID = .invalid
            }
        }
        
        do{
            let flashcards = try await service.generateFlashcards(topic: topic, difficulty: difficulty, count: numberOfCards)
            self.flashcards = flashcards
            self.generatedSetId = UUID().uuidString.lowercased()
            print("Generated \(flashcards.count) flashcards, Set ID: \(generatedSetId)")
        }catch let error as GenerateFlashcardsError{
            self.errorMessage = error.localizedDescription
        } catch {
            print("GenerateViewModel error: \(error)")
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
      
        isLoading = false
    }
    
    func generateAndReturn() async throws -> ([Flashcard], String) {
        guard !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw GenerateFlashcardsError.emptyTopic
        }
        
        var bgTaskID: UIBackgroundTaskIdentifier = .invalid
        bgTaskID = UIApplication.shared.beginBackgroundTask(withName: "GenerateFlashcards") {
            // End the task if time expires.
            UIApplication.shared.endBackgroundTask(bgTaskID)
            bgTaskID = .invalid
        }
        
        defer {
            if bgTaskID != .invalid {
                UIApplication.shared.endBackgroundTask(bgTaskID)
                bgTaskID = .invalid
            }
        }
        
        let flashcards = try await service.generateFlashcards(topic: topic, difficulty: difficulty, count: numberOfCards)
        let setId = UUID().uuidString.lowercased()
        
        // Update local state just in case we come back, but the caller handles the result
        self.flashcards = flashcards
        self.generatedSetId = setId
        
        return (flashcards, setId)
    }
    
    
}
