//
//  Settings.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    @State private var isMusicEnabled: Bool = true //default music playing
    @State private var selectedTime: Date = Date()  // Use for temporary notification, uneeded as code is commented out

    var body: some View {
        VStack {

            Text("Settings")
                .font(.largeTitle)
                .padding()

            List {
                Toggle("Enable Background Music", isOn: $isMusicEnabled)
                    .onChange(of: isMusicEnabled) { value in
                        if value {
                            AudioManager.startBackgroundMusic() //asks the auto manager to start music
                        } else {
                            AudioManager.stopBackgroundMusic() // stop of not selected, mute button also works
                        }
                    }
                    .padding()
                // Set up notifications, commented out and can be implemented later
                /*VStack {
                    DatePicker(
                        "Select Notification Time",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()

                    Button("Schedule Notification") {
                        let notificationDate =
                            NotificationManager.getNotificationDate(
                                from: selectedTime
                            )
                        NotificationManager.scheduleNotification(
                            at: notificationDate
                        )
                        print("pressing ok")
                    }
                    .buttonStyle(.borderedProminent).tint(.green)
                    Button("Test in 5s") {
                        NotificationManager.scheduleImmediateNotification()
                        print("test notification is scheduled")
                    }
                    .buttonStyle(.borderedProminent).tint(.blue)
                }*/

            }
            .background(Color.green)
            .cornerRadius(20)

            Button("back") {
                dismiss() // go back to previous view, dismiss popup
            }
            .padding()
            .background(Color("Pink"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title)

            Spacer()
        }
        .padding()
        .onAppear {
            // request notification permissions
            NotificationManager.requestPermissions() //request notification access if not provided already
        }
    }
}

#Preview {
    Settings()
}
