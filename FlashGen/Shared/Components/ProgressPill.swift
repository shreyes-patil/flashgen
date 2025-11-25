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
    }
}

