//
//  TaskAppSwiftDataApp.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 07.05.24.
//

import SwiftUI
import SwiftData

@main
struct TaskAppSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AufgabenView()
                TagsView()
            }.onAppear {
                NotificationManager.instance.requestAuthForNotification()
            }
        }
        .modelContainer(createContainer())
    }
}

func createContainer() -> ModelContainer {
    let schema = Schema([
        Aufgabe.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)
    do {
        return try ModelContainer(for: schema, configurations: configuration)
    } catch {
        fatalError("Could not created ModelContainer \(error)")
    }
}
