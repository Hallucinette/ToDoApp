//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 04/01/2023.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(NotificationHandler.self) var notificationHandler

    var body: some Scene {
        WindowGroup {
            ContentView()
          //  NotificationView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
