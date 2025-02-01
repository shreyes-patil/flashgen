//
//  FlashGenApp.swift
//  FlashGen
//
//  Created by Shreyas Patil on 2/1/25.
//

import SwiftUI

@main
struct FlashGenApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
