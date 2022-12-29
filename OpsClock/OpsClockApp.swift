//
//  OpsClockApp.swift
//  OpsClock
//
//  Created by Daniel Skowroński on 29/12/2022.
//

import SwiftUI

@main
struct OpsClockApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
