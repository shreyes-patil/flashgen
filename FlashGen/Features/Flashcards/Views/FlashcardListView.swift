//
//  FlashcardListView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import SwiftUI

struct FlashcardListView: View {
    let flashcards: [Flashcard]
    let onFlashcardTap :((Flashcard) -> Void)?=nil
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            ForEach(flashcards){ card in
                Button{
                    onFlashcardTap?(card)
                } label: {
                    HStack{
                        Text("Q")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding(8)
                            .background(Color.yellow)
                            .clipShape(Circle())
                        
                        Text(card.question)
                            .font(.body)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .background(
                    RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
                        .fill(Color(.systemBackground))
                )
                .overlay(
                    RoundedCornerShape(radius: 16, corners: [.topLeft,.bottomRight])
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
                .shadow(radius: 1)
            }
        }
    }
}

//#Preview {
//    FlashcardListView()
//}
