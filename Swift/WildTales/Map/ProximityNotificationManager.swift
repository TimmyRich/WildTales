//
//  ProximityNotificationManager.swift
//  WildTales
//
//  Created by Kurt McCullough on 19/4/2025.
//

// This function requests for notification permissions when opening the app, should be called whenever a notification is about to be sent
// some exampels were provided and used from (https://developer.apple.com/documentation/usernotifications/unusernotificationcenter)
//
// It was originally used to create proximity notifications but we had found a better and more reliable way

import Foundation
import UserNotifications

class ProximityNotificationManager {

    static let shared = ProximityNotificationManager()

    private init() {}

    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            granted,
            error in
            if let error = error {
                print(
                    "Notification permission error: \(error.localizedDescription)"
                )
            }
        }
    }

    //schedules notifications for 12:00 every day
    // This was created with ChatGPT with the prompt "create some code that sends the user a notification every day at 12:00"
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Lets Go Explore!"
        content.body = "Jump onto WildTales and explore the world around you!"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: "dailyNotification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    //end AI generated code

}
