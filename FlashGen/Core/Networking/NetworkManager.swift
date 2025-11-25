//
//  NetworkManager.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://127.0.0.1:3000"
    
    private init() {}
    
    func generateFlashcards(topic: String, count: Int, difficulty: String) async throws -> GenerateFlashcardsResponse {
        let url = URL(string: "\(baseURL)/ai/flashcards/generate/topic")!
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 120 // Increase timeout to 2 minutes for AI generation
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "topic": topic,
            "count": count,
            "difficulty": difficulty
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Received response: \(jsonString)")
        }
        
        do {
            return try JSONDecoder().decode(GenerateFlashcardsResponse.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}

enum NetworkError: Error {
    case invalidResponse
    case decodingError
}

// Response models
struct GenerateFlashcardsResponse: Codable {
    let success: Bool
    let data: FlashcardData
}

struct FlashcardData: Codable {
    let flashcards: [GeneratedFlashcard]
    let count: Int
    let source: String
    let topic: String
    let difficulty: String
}

struct GeneratedFlashcard: Codable {
    let question: String
    let answer: String
    let difficulty: String
    let tags: [String]
    let source: String?
    let created_at: String
    
    enum CodingKeys: String, CodingKey {
        case question, answer, difficulty, tags, source
        case created_at = "created_at"
    }
}
