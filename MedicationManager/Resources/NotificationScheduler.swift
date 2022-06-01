//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Curt McCune on 6/1/22.
//

import UserNotifications

class NotificationScheduler {
    
    func scheduleNotifications(for medication: Medication) {
        guard let id = medication.id, !id.isEmpty else {return}
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to take your \(medication.name ?? "")"
        content.sound = .default
        content.userInfo = [Strings.medicationIDKey :id]
        content.categoryIdentifier = Strings.notificationCategoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notifications request: \(error)")
            }
        }
    }
 
    func cancelNotifications(for medication: Medication) {
        guard let id = medication.id else {return}
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        
    }
}
