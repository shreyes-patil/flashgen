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
                id: UUID(uuidString: "E851172A-8B6C-498A-8507-6B7AF52803C1") ?? UUID(),
                question: "What's new in FlashGen?",
                answer: "We've added support for scanning documents and uploading PDFs to generate flashcards instantly!"
            ),
            Flashcard(
                id: UUID(uuidString: "B392815F-2947-4984-9AB8-D673752695E2") ?? UUID(),
                question: "How do I scan a document?",
                answer: "Tap the '+' icon in the topic input field and select 'Scan Document'. Point your camera at any text to extract it."
            ),
            Flashcard(
                id: UUID(uuidString: "7CE13840-FE21-4CA3-A964-1A58D6E12F58") ?? UUID(),
                question: "Can I upload PDFs?",
                answer: "Yes! Tap the '+' icon and select 'Upload PDF'. You can choose any PDF file from your device."
            ),
            Flashcard(
                id: UUID(uuidString: "DF9B3482-1A65-4923-8B7C-5F1E937418D6") ?? UUID(),
                question: "How many pages can I process?",
                answer: "Currently, we support processing up to 10 pages of a PDF to ensure fast generation."
            ),
            Flashcard(
                id: UUID(uuidString: "42A1D7FA-8924-4B61-9387-5C1896324D59") ?? UUID(),
                question: "Is it free?",
                answer: "Yes, these new features are free to use for all users. Happy learning!"
            ),
            Flashcard(
                id: UUID(uuidString: "98E5C317-2F6B-4815-A893-6C52873194B1") ?? UUID(),
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
