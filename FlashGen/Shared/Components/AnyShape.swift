//
//  AnyShape.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/28/25.
//

import SwiftUI

struct AnyShape: Shape {
    private let builder: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        builder = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        builder(rect)
    }
}
