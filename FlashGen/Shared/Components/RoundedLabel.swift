//
//  RoundedLabel.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import SwiftUI

struct RoundedLabel: View {
    
    let text: String
    let color : Color
    let radius : CGFloat = 20
    
    
    var body: some View {
        
        
        Text(text)
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedCornerShape(radius: radius, corners: [.topLeft, .bottomRight])
                    .fill(color)
            )
            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}


