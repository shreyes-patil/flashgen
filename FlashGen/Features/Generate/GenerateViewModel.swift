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
    @Published var generatedText: String? = nil
    
    private let service : FlashcardGeneratorServiceProtocol
    private let extractionService: ContentExtractionServiceProtocol
    
    init(service: FlashcardGeneratorServiceProtocol, extractionService: ContentExtractionServiceProtocol = ContentExtractionService()){
        self.service = service
        self.extractionService = extractionService
    }
    
    func extractText(from image: UIImage) async {
        isLoading = true
        errorMessage = nil
        do {
            let text = try await extractionService.extractText(from: image)
            self.generatedText = text
            self.topic = "Generated from Image" // Placeholder for UI
        } catch {
            self.errorMessage = NSLocalizedString("error.extraction.image", comment: "")
        }
        isLoading = false
    }
    
    func extractText(from pdfURL: URL) async {
        isLoading = true
        errorMessage = nil
        do {
            let text = try await extractionService.extractText(from: pdfURL)
            self.generatedText = text
            self.topic = pdfURL.lastPathComponent
        } catch {
            self.errorMessage = NSLocalizedString("error.extraction.pdf", comment: "")
        }
        isLoading = false
    }
    
    func clearGeneratedText() {
        generatedText = nil
        topic = ""
    }
    
    func generate() async{
        let topicToUse = generatedText ?? topic
        
        guard !topicToUse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
            // If we have generated text, we send that as the "topic" to the backend
            // The backend prompt should be robust enough to handle raw text
            let flashcards = try await service.generateFlashcards(topic: topicToUse, difficulty: difficulty, count: numberOfCards)
            self.flashcards = flashcards
            self.generatedSetId = UUID().uuidString.lowercased()
            print("Generated \(flashcards.count) flashcards, Set ID: \(generatedSetId)")
        }catch let error as GenerateFlashcardsError{
            self.errorMessage = error.localizedDescription
        } catch {
            print("GenerateViewModel error: \(error)")
            self.errorMessage = String(format: NSLocalizedString("error.prefix", comment: ""), error.localizedDescription)
        }
      
        isLoading = false
    }
    
    func generateAndReturn() async throws -> ([Flashcard], String) {
        let topicToUse = generatedText ?? topic
        
        guard !topicToUse.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
        
        let flashcards = try await service.generateFlashcards(topic: topicToUse, difficulty: difficulty, count: numberOfCards)
        let setId = UUID().uuidString.lowercased()
        
        // Update local state just in case we come back, but the caller handles the result
        self.flashcards = flashcards
        self.generatedSetId = setId
        
        return (flashcards, setId)
    }
    
    
}
