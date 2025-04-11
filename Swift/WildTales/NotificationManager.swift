//
//  Notification.swift
//  WildTales
//
//  Created by Wei on 2025/4/11.
//  Inspired by https://github.com/soapyigu/Swift-30-Projects/tree/master/Project%2027%20-%20NotificationsUI

import SwiftUI
import UserNotifications

struct NotificationManager {
    
    static let delegate = NotificationDelegate()
    
    // Get notification time from date picker
    static func getNotificationDate(from time: Date) -> Date {
           let calendar = Calendar.current
           let now = Date()
           
           let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
           var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
           
           dateComponents.hour = timeComponents.hour
           dateComponents.minute = timeComponents.minute
           
           return calendar.date(from: dateComponents) ?? now
       }
    
    // Test for notification
    static func scheduleImmediateNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "Welcome to WildTale"
        content.sound = UNNotificationSound.default
        
        // Send in 5sec from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Make a notification request.
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling immediate notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled to fire in 5 seconds")
            }
        }
    }
    
    static func setupNotifications() {
        UNUserNotificationCenter.current().delegate = delegate
    }
       
    // Use the notification center
    static func scheduleNotification(at date: Date) {
    
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Approaching Destination"
        content.body = "You are close to the mission location"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "normal"
        
        // Use image
        if let path = Bundle.main.path(forResource: "PawIcon", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "Paw", url: url, options: nil)
                content.attachments = [attachment]
              } catch {
                  print("The notification image is not loaded.")
              }
        }
        
        // Create the notification request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(date)")
            }
        }
    }
    
    // request notification permissions
    static func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }
    
    // Interface for processing notification
    class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
        // It allows notifications to appear when device is not locked
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
        ) {
            // show banner
            completionHandler([.banner, .sound])
        }
    }
}
