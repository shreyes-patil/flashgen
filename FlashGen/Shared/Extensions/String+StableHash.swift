//
//  String+StableHash.swift
//  FlashGen
//
//  Created by Shreyas Patil on 11/25/25.
//

import Foundation

extension String {
    /// A stable hash value that remains constant across app launches.
    /// Uses the DJB2 algorithm.
    var stableHash: Int {
        var hash = 5381
        for char in self.utf8 {
            hash = ((hash << 5) &+ hash) &+ Int(char)
        }
        return hash
    }
}
