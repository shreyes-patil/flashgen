//
//  ProgressPill.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/14/25.
//

import SwiftUI

struct ProgressPill: View {
    let text : String
    
    var body: some View {
        Text(text).font(.caption).bold()
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(.thinMaterial)
            .cornerMask(12, [.topLeft, .topRight])
            .cornerStroke(12, [.topLeft, .topRight], color: .primary.opacity(0.08))
    }
}

