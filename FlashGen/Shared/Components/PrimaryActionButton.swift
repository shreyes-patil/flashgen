//
//  PrimaryActionButton.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/24/25.
//

import SwiftUI

struct PrimaryActionButton: View {
    let titleKey: LocalizedStringKey
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text(titleKey)
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .background(Color.blue)
        .clipShape(
            RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
        )
        .shadow(radius: 4)
        .padding(.horizontal, 2)
        .disabled(isDisabled)
        .accessibilityLabel(Text(titleKey))
    }
}
