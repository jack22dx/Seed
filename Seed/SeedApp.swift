//
//  SeedApp.swift
//  Seed
//
//  Created by Jack on 4/11/2024.
//

import SwiftUI

@main
struct SeedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
