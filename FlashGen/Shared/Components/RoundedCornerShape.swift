//
//  RoundedCornerShape.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/3/25.
//

import SwiftUI

struct RoundedCornerShape: Shape {
    var radius : CGFloat
    var corners : UIRectCorner
    
    
    func path(in rect: CGRect) -> Path {
        let path  = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

