//
//  ProximityNotificationManager.swift
//  WildTales
//
//  Created by Kurt McCullough on 19/4/2025.
//

// ProximityNotificationManager.swift
// some exampels were provided and used from (https://developer.apple.com/documentation/usernotifications/unusernotificationcenter)
//
// This pretty much just sets up the notifications for the user when they get close to a spot, unusernotificationceter makes it easy to do this
// Just have to do it for each location when loading the map

import CoreLocation
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

    func scheduleProximityNotification(for location: Location) {
        let content = UNMutableNotificationContent()
        content.title = "You're nearby!"
        content.body = "You're close to \(location.name)"
        content.sound = .default

        let region = CLCircularRegion(
            center: location.coordinate,
            radius: 50,  // meters
            identifier: location.id.uuidString
        )
        region.notifyOnEntry = true
        region.notifyOnExit = true  // This ensures it notifies when you leave and re-enter

        let trigger = UNLocationNotificationTrigger(
            region: region,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        // If there was an error with notifying user
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(
                    "Error scheduling proximity notification: \(error.localizedDescription)"
                )
            }
        }
    }

    func cancelNotifications(for location: Location) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [location.id.uuidString])
    }
}
