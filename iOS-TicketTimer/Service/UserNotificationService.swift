//
//  UserNotificationService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/24.
//

import UserNotifications

class UserNotificationService {
    static let shared = UserNotificationService()
    
    func sendNotification(alarm: LocalAlarm) {
        let content = UNMutableNotificationContent()
        content.title = alarm.title
        content.body = alarm.body.trimmingCharacters(in: ["\n", "\r", "\t"])
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: alarm.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error)
            } else {
                self.logScheduledNotifications()
            }
        }
    }
    
    func cancelNotification(alarms: [LocalAlarm]) {
        let identifiers = alarms.map { $0.id }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func logScheduledNotifications() {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { (requests) in
                print("\n----- PENDING NOTIFICATIONS -----")
                for request in requests {
                    print(request)
                }
                print("----- END ----- \n")
            }
        }
}
