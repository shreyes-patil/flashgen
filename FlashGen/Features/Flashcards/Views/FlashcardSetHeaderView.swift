//
//  FlashcardSetHeaderView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/3/25.
//

import SwiftUI

struct FlashcardSetHeaderView: View {
    let title: String
    let numberOfCards: Int
    let lastReviewed: String
    let color: Color
    
    // Pastel "Post-it" Colors
    private let paleMint = Color(hex: "A7F3D0")
    private let canaryYellow = Color(hex: "FDE68A")
    private let softRose = Color(hex: "FECACA")
    private let softBlue = Color(hex: "BFDBFE")
    private let maskingTape = Color(hex: "E3DAC9") // True Neutral Bone/Beige
    
    // Dynamic Secondary Color
    private var secondaryColor: Color {
        if color == softRose { return paleMint }
        if color == canaryYellow { return softBlue }
        return softRose
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // 1. Big Sticky (Title) - Anchored Left-Center (~55% width)
                StickyNote(text: title, color: color, rotation: -3)
                    .frame(width: width * 0.55, height: height * 0.75)
                    .position(x: width * 0.35, y: height * 0.45)
                    .zIndex(2)
                
                // 2. Small Sticky (Count) - Peeking Top Right (~30% width)
                StickyNote(text: "\(numberOfCards) Cards", color: secondaryColor, rotation: 4)
                    .frame(width: width * 0.30, height: height * 0.6)
                    .position(x: width * 0.78, y: height * 0.35)
                    .zIndex(1)
                
                // 3. Washi Tape / Tag - Bottom Center
                Text("Last reviewed: \(lastReviewed)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(maskingTape.opacity(0.9))
                    .clipShape(RoundedCornerShape(radius: 10, corners: [.topLeft, .bottomRight]))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    .rotationEffect(.degrees(-1))
                    .position(x: width * 0.5, y: height * 0.88)
                    .zIndex(3)
            }
        }
        .frame(height: 120) // Fixed height container, internal layout scales horizontally
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(title). \(numberOfCards) flashcards. Last reviewed: \(lastReviewed)"))
    }
}

private struct StickyNote: View {
    let text: String
    let color: Color
    let rotation: Double
    
    var body: some View {
        Text(text)
            .font(.custom("Marker Felt", size: 24))
            .minimumScaleFactor(0.4) // Allow scaling for long titles
            .foregroundStyle(.black.opacity(0.85))
            .multilineTextAlignment(.center)
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the assigned frame
            .background(color)
            .clipShape(RoundedCornerShape(radius: 4, corners: [.topLeft, .bottomRight]))
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .rotationEffect(.degrees(rotation))
    }
}
#Preview {
    FlashcardSetHeaderView(
        title: "Calculus Formulas",
        numberOfCards: 20,
        lastReviewed: "2 days ago",
        color: Color(hex: "A7F3D0")
    )
}


