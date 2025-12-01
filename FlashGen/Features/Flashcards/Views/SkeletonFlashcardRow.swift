//
//  SkeletonFlashcardRow.swift
//  FlashGen
//
//  Created by Shreyas Patil on 12/1/25.
//

import SwiftUI

struct SkeletonFlashcardRow: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            // "Q" Circle placeholder
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .padding(8)
            
            // Question text placeholder
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 20)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .shadow(radius: 1)
        .opacity(isAnimating ? 0.5 : 1.0)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        VStack {
            SkeletonFlashcardRow()
            SkeletonFlashcardRow()
            SkeletonFlashcardRow()
        }
        .padding()
    }
}
