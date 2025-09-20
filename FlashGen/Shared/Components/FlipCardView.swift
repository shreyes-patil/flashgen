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
    
    
    var body: some View {
        ZStack{
                        face(question)
                .opacity(isRevealed ? 0 : 1)
                .rotation3DEffect(.degrees(isRevealed ? 180 : 0), axis: (0,1,0))
                        face(answer)
                .opacity(isRevealed ? 1:0)
                .rotation3DEffect(.degrees(isRevealed ? 0 : -180), axis: (0,1,0))
        }
        
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: isRevealed)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isRevealed ? "Answer .\(answer)": "Question .\(question) Double tap to reveal")
    }
        @ViewBuilder
    private func face(_ text: String) -> some View {
        ScrollView{
            Text(text)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.85)
                .padding()
            
        }
    }
}


