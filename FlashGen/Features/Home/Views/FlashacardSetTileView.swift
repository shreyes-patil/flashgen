//
//  FlashacardSetTileView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/17/25.
//

import SwiftUI

struct FlashacardSetTileView: View {
    
    let set: FlashcardSet
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(set.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .accessibilityLabel(Text("Flashcard set title: \(set.title)"))
            
            Text(String.localizedStringWithFormat(
                NSLocalizedString(
                    "Last reviewed: %@",
                    comment: "Flashcard set tile view - last reviewed date"
                ),set.lastReviewed.relativeFormattedString()))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .accessibilityLabel(Text("Last reviewed on \(set.lastReviewed.relativeFormattedString)"))
            
            ZStack{
                Circle()
                    .strokeBorder(lineWidth: 6)
                    .foregroundColor(.white.opacity(0.3))
                
                    .overlay(
                        Circle()
                            .trim(from: 0.75, to: 1)
                            .stroke(Color.yellow, lineWidth: 6)
                            .rotationEffect(.degrees(-90))
                    )
                    .frame(width: 56, height: 56)
                    .accessibilityHidden(true)
                
                Image(systemName: set.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
            }
            
            Text(String.localizedStringWithFormat(NSLocalizedString("%d flashcards", comment: "Number of flashcards"),set.numberofCards))
                .font(.footnote)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.yellow)
                .foregroundStyle(.blue)
                .cornerRadius(12)
                .accessibilityLabel(Text("\(set.numberofCards) flashcards availaible"))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight:160)
        .background(Color.blue.opacity(0.8))
        .clipShape(RoundedCornerShape(radius: 34, corners: [.topLeft, .bottomRight]))
        .shadow(color: .black.opacity(0.1),radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
//    FlashacardSetTileView(set: FlashcardSet.init(name: <#T##String#>, numberofCards: <#T##Int#>, lastReviewed: <#T##Date#>))
}
