//
//  NotificationCenter.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 25.11.2021.
//

import Foundation
import UserNotifications

class NotificationCenter {
    
    // MARK: - Properties
    
    let center = UNUserNotificationCenter()
    
    // MARK: - Methods
    
    func requestNotification() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешений получено")
                return
            }
            self.sendNotificationRequest(content: self.makeNotificationContent(),
                                         trigger: self.makeNotificationTrigger()
            )
        }
    }
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "Hey"
        content.body = "Let's build a new route"
        content.badge = 1
        return content
    }
    
    func makeNotificationTrigger() {
        /// Интервал уведомления
        return UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        /// Календарь показа уведомления
        var dateInfo = DateComponents()
        dateInfo.minute = 30
        return UNCalendarNotificationTrigger(dateMatching: dateInfo,
                                             repeats: false)
    }
    
    func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm",
                                            content: content,
                                            trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
