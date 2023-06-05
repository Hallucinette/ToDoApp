//
//  Notifications.swift
//  ToDoListApp
//
//  Created by Amelie Pocchiolo on 06/01/2023.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHandler: NSObject, UIApplicationDelegate  {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Show local notification in foreground when app is open
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Access granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

// Conform to UNUserNotificationCenterDelegate to show local notification in foreground
extension NotificationHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
