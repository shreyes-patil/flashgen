import Foundation

/// Notifications used across the app related to Flashcard Sets.
extension Notification.Name {
    /// Posted when flashcard sets are created, updated, deleted, or otherwise change.
    public static let flashcardSetsDidChange = Notification.Name("flashcardSetsDidChange")
}