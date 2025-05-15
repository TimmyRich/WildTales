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

}
