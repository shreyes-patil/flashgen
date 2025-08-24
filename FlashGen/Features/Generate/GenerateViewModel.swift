//
//  GenerateViewModel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import Foundation

@MainActor
final class GenerateViewModel: ObservableObject {
    @Published var topic : String = ""
    @Published var difficulty : FlashcardDifficulty = .easy
    @Published var numberOfCards : Int = 10
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    @Published var flashcards : [Flashcard] = []
    
    private let service : FlashcardGeneratorServiceProtocol
    
    init(service: FlashcardGeneratorServiceProtocol){
        self.service = service
    }
    
    func generate() async{
        guard !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter a topic"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do{
            let flashcards = try await service.generateFlashcards(topic: topic, difficulty: difficulty, count: numberOfCards)
            self.flashcards = flashcards
        }catch{
            self.errorMessage = "Failed to generate flashcards. Please try again later."
        }
        isLoading = false
    }
    
    
}
