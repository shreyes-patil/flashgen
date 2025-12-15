//
//  ContentExtractionService.swift
//  FlashGen
//
//  Created by Shreyas Patil on 12/09/25.
//

import Foundation
import UIKit
import Vision
import PDFKit

protocol ContentExtractionServiceProtocol {
    func extractText(from image: UIImage) async throws -> String
    func extractText(from pdfURL: URL) async throws -> String
}

final class ContentExtractionService: ContentExtractionServiceProtocol {
    
    enum ExtractionError: Error {
        case invalidImage
        case extractionFailed
        case invalidPDF
    }
    
    func extractText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw ExtractionError.invalidImage
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: ExtractionError.extractionFailed)
                    return
                }
                
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                continuation.resume(returning: text)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func extractText(from pdfURL: URL) async throws -> String {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            throw ExtractionError.invalidPDF
        }
        
        var fullText = ""
        let pageCount = pdfDocument.pageCount
        
        // Limit to first 10 pages to avoid timeout/memory issues for now
        let limit = min(pageCount, 10)
        
        for i in 0..<limit {
            if let page = pdfDocument.page(at: i), let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        
        return fullText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
