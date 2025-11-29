//
//  NetworkManager.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://flashgen-backend-nextjs.vercel.app"
    
    private init() {}
    
    func generateFlashcards(topic: String, count: Int, difficulty: String) async throws -> GenerateFlashcardsResponse {
        let url = URL(string: "\(baseURL)/api/ai/flashcards/generate/text")!
        
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
        
        if let _ = String(data: data, encoding: .utf8) {
            // Log response in debug only
            #if DEBUG
            // print("Received response: \(jsonString)")
            #endif
        }
        
        do {
            return try JSONDecoder().decode(GenerateFlashcardsResponse.self, from: data)
        } catch {
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
    let topic: String?
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
