//
//  GenerateFlashcardsError.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/27/25.
//

import Foundation

enum GenerateFlashcardsError: LocalizedError {
    case emptyTopic
    case invalidInput(String)
    case networkError
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emptyTopic:
            return NSLocalizedString("error.empty_topic", comment: "")
        case .invalidInput(let reason):
            return reason
        case .networkError:
            return NSLocalizedString("error.network", comment: "")
        case .decodingError:
            return "Error decoding JSON"
        case .unknown:
            return NSLocalizedString("error.unknown" , comment: "")
        }
    }
}

