//
//  WhatsNewService.swift
//  FlashGen
//
//  Created by Shreyas Patil on 12/14/25.
//

import Foundation

final class WhatsNewService {
    static let shared = WhatsNewService()
    
    private let lastLaunchedVersionKey = "last_launched_version"
    private let whatsNewSetId = "whats_new_v2_0" // Unique ID for this version's set
    
    var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    func checkForUpdates() -> FlashcardSet? {
        let lastVersion = UserDefaults.standard.string(forKey: lastLaunchedVersionKey)
        
        // Check if this is a new version (or first run of this version)
        // For testing purposes, we can comment out the version check or increment the version in Info.plist
        if lastVersion != currentVersion {
            UserDefaults.standard.set(currentVersion, forKey: lastLaunchedVersionKey)
            return generateWhatsNewSet()
        }
        
        return nil
    }
    
    private func generateWhatsNewSet() -> FlashcardSet {
        let cards = [
            Flashcard(
                id: UUID(),
                question: "What's new in FlashGen?",
                answer: "We've added support for scanning documents and uploading PDFs to generate flashcards instantly!"
            ),
            Flashcard(
                id: UUID(),
                question: "How do I scan a document?",
                answer: "Tap the '+' icon in the topic input field and select 'Scan Document'. Point your camera at any text to extract it."
            ),
            Flashcard(
                id: UUID(),
                question: "Can I upload PDFs?",
                answer: "Yes! Tap the '+' icon and select 'Upload PDF'. You can choose any PDF file from your device."
            ),
            Flashcard(
                id: UUID(),
                question: "How many pages can I process?",
                answer: "Currently, we support processing up to 10 pages of a PDF to ensure fast generation."
            ),
            Flashcard(
                id: UUID(),
                question: "Is it free?",
                answer: "Yes, these new features are free to use for all users. Happy learning!"
            ),
            Flashcard(
                id: UUID(),
                question: "Are my documents stored?",
                answer: "No. Your documents are processed securely on-device or temporarily for generation and are never stored on our servers."
            )
        ]
        
        return FlashcardSet(
            id: whatsNewSetId,
            title: "What's New in v\(currentVersion)",
            difficulty: .medium,
            cards: cards,
            createdAt: Date(),
            updatedAt: Date(),
            lastReviewed: Date(), // This will be displayed as "Updated: [Date]"
            sourceType: .text,
            sourceURL: nil,
            pdfPageRange: nil,
            notes: "Welcome to the new update! You can delete this set once you've read it."
        )
    }
    
    func isWhatsNewSet(id: String) -> Bool {
        return id == whatsNewSetId
    }
}
