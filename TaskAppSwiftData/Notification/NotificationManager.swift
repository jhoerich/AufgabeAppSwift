//
//  NotificationManager.swift
//  TaskAppSwiftData
//
//  Created by Janek Höricht on 17.05.24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestAuthForNotification() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert]) {
            success, error in
            if let error = error {
                print("Fehler: \(error.localizedDescription)")
            } else {
                print("Erfolg")
            }
        }
    }
    
    func scheduledNotificationFuerAufgabe(aufgabe: Aufgabe){
        let notificationContent = UNMutableNotificationContent()
        let calender = Calendar.current
        
        notificationContent.title = "Erinnerung"
        notificationContent.subtitle = "Aufgabe \(aufgabe.bezeichnung) ist noch nicht abgeschlossen!"
        notificationContent.badge = 1
        
        var dateComponents = DateComponents()
        let aufgabeAbschliessenZeitpunkt = Date(timeIntervalSince1970: aufgabe.zeitpunktZumAbschliessen)
        var erinnerungsZeitpunkt = calender.date(byAdding: .minute, value: -30, to: aufgabeAbschliessenZeitpunkt)!
        if erinnerungsZeitpunkt < Date() {
            erinnerungsZeitpunkt = calender.date(byAdding: .minute, value: -1, to: aufgabeAbschliessenZeitpunkt)!
        }
        
        dateComponents.day = calender.component(.day, from: erinnerungsZeitpunkt)
        dateComponents.month = calender.component(.month, from: erinnerungsZeitpunkt)
        dateComponents.year = calender.component(.year, from: erinnerungsZeitpunkt)
        dateComponents.hour = calender.component(.hour, from: erinnerungsZeitpunkt)
        dateComponents.minute = calender.component(.minute, from: erinnerungsZeitpunkt)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Erstellen einer Anfrage
        let request = UNNotificationRequest(identifier: "\(aufgabe.id)", content: notificationContent, trigger: trigger)
        
        // Hinzufügen der Anfrage zum UNUserNotificationCenter
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Fehler beim Planen der Benachrichtigung: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteScheduledNotification(aufgabe: Aufgabe) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(aufgabe.id)"])
    }
}
