//
//  FlipCardView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/14/25.
//

import SwiftUI

struct FlipCardView: View {
    let question: String
    let answer: String
    let isRevealed: Bool
    let color: Color
    
    var body: some View {
        ZStack {
            // Question side
            face(question, isAnswer: false)
                .opacity(isRevealed ? 0 : 1)
                .rotation3DEffect(.degrees(isRevealed ? 180 : 0), axis: (0,1,0))
            
            // Answer side
            face(answer, isAnswer: true)
                .opacity(isRevealed ? 1 : 0)
                .rotation3DEffect(.degrees(isRevealed ? 0 : -180), axis: (0,1,0))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isRevealed)
    }
    
    @ViewBuilder
    private func face(_ text: String, isAnswer: Bool) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Minimal label
                Text(isAnswer ? LocalizedStringKey("flashcard.answer") : LocalizedStringKey("flashcard.question"))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.8))
                    .textCase(.uppercase)
                    .tracking(0.8)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(color)
                    .clipShape(RoundedCornerShape(radius: 12, corners: [.topLeft, .bottomRight]))
                
                Text(text)
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(8) // Increased line spacing for readability
            }
            .padding(32) // Increased padding
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(Color(.systemBackground))
        .cornerMask(34, [.topLeft, .bottomRight])
        // Colored border matching the set color
        .overlay(
            RoundedCornerShape(radius: 34, corners: [.topLeft, .bottomRight])
                .stroke(color, lineWidth: 3)
        )
        // Colored shadow matching the set color
        .shadow(color: color.opacity(0.25), radius: 10, x: 0, y: 4)
    }
}
