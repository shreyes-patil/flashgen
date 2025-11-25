//
//  FlashcardRowView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/27/25.
//

import SwiftUI

struct FlashcardRowView: View {
    let card: Flashcard
    var color: Color = .yellow
    let onTap: ((Flashcard) -> Void)?

    var body: some View {
        Button {
            onTap?(card)
        } label: {
            HStack {
                Text("Q")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding(8)
                    .background(color)
                    .clipShape(Circle())
                    .accessibilityHidden(true)

                Text(card.question ?? "")
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
        }
        .accessibilityLabel(
            Text("\(NSLocalizedString("quetion_label", comment: "Question label")): \(card.question ?? "")")
        )
        .accessibilityAddTraits(.isButton)
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(radius: 1)
    }
}
