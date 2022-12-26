//
//  Notifications.swift
//  NeatweekiOS
//
//  Created by Mihnea on 12/26/22.
//

import Foundation
import UserNotifications


class LocalNotifications {
    static let sharedInstance = LocalNotifications()
    
    private init() {}
    
    public func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {succes, err in
            if let err = err {print(err.localizedDescription)}   
        }
    }
    
    public func beginningOfWeekNotification() {
        var components = DateComponents()
        components.weekday = 1
        components.hour = 19
        components.minute = 24
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: components)
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "New week"
        content.body = "Move your tasks around populate your Week page!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "weekly"
        
        let request = UNNotificationRequest(identifier: "weekly", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
        
    }
    
    
}
