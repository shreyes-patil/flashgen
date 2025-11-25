//
//  FlashacardSetTileView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/17/25.
//

import SwiftUI

struct FlashcardSetTileView: View {
    let set: FlashcardSet
    let backgroundColor: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(set.title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.black.opacity(0.8))
            
            Text(String.localizedStringWithFormat(
                NSLocalizedString(
                    "Last reviewed: %@",
                    comment: "Flashcard set tile view - last reviewed date"
                ),set.lastReviewed.relativeFormattedString()))
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.6))
            
//            ZStack{
//                Circle()
//                    .strokeBorder(lineWidth: 6)
//                    .foregroundColor(.black.opacity(0.1))
//                    .overlay(
//                        Circle()
//                            .trim(from: 0.75, to: 1)
//                            .stroke(Color.yellow, lineWidth: 6)
//                            .rotationEffect(.degrees(-90))
//                    )
//                    .frame(width: 56, height: 56)
//                
//                Image(systemName: "book.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 24)
//                    .foregroundStyle(.black.opacity(0.7))
//            }
            
            HStack(spacing: 6) {
                
                Text(String.localizedStringWithFormat(NSLocalizedString("%d flashcards", comment: "Number of flashcards"),set.cards.count))
                    .font(.footnote)
                Circle()
                    .fill(set.difficulty.color)
                    .frame(width: 8, height: 8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white)
            .foregroundStyle(.black)
            .cornerRadius(12)
        }
        .padding()
        .frame(height: 180) 
                .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedCornerShape(radius: 34, corners: [.topLeft, .bottomRight]))
        .shadow(color: .black.opacity(0.1),radius: 4, x: 0, y: 2)
    }
}

#Preview {
//    FlashacardSetTileView(set: FlashcardSet.init(name: <#T##String#>, numberofCards: <#T##Int#>, lastReviewed: <#T##Date#>))
}
