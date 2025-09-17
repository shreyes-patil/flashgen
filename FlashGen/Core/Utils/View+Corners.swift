//
//  View+Corners.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/14/25.
//

import SwiftUI


extension View {
    func cornerMask(_ radius : CGFloat, _ corners : UIRectCorner) -> some View {
        self.clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
    
    func cornerStroke(_ radius : CGFloat, _ corners: UIRectCorner, color: Color = .primary.opacity(0.06), linewidth : CGFloat = 1) -> some View {
        self.overlay(
            RoundedCornerShape(radius: radius, corners: corners)
                .stroke(color, lineWidth: linewidth)
        )
    }
}

