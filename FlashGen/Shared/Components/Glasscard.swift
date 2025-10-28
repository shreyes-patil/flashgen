//
//  Glasscard.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/14/25.
//

import SwiftUI

struct GlassCard<Content:View>: View {
    let radius : CGFloat
    let corners : UIRectCorner
    @ViewBuilder var content: Content
    
    init(radius: CGFloat = 16, corners: UIRectCorner = [.topLeft, .bottomRight], @ViewBuilder content: () -> Content) {
        self.radius = radius
        self.corners = corners
        self.content = content()
    }
    
    var body: some View {
        ZStack{content.padding(20)}
            .frame(maxWidth: .infinity, minHeight: 300)
            .background(.ultraThinMaterial)
            .cornerMask(radius, corners)
            .cornerStroke(radius, corners)
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            .contentShape(RoundedCornerShape(radius: radius, corners: corners))
    }
    
}
