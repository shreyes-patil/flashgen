//
//  Date+Extension.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/3/25.
//

import Foundation


extension Date {
    func relativeFormattedString(style: RelativeDateTimeFormatter.UnitsStyle = .full) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = style
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
