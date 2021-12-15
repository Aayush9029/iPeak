//
//  iPeakApp.swift
//  iPeak
//
//  Created by Aayush Pokharel on 2021-12-14.
//

import SwiftUI

@main
struct iPeakApp: App {
    @StateObject var ipvm = iPeakViewModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(ipvm)
                .frame(width: 500, height: 400)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
