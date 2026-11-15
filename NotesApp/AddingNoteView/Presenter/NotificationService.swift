//
//  NotificationService.swift
//  NotesApp
//
//  Created by Дима Люфт on 09.11.2026.
//

import UserNotifications

protocol NotificationServiceProtocol {
    func requestPermission(completion: @escaping (Bool)-> Void)
    func schedule(noteId: String, title: String, body: String, date: Date)
    func cancel(noteId: String)
}

final class NotificationService: NotificationServiceProtocol {
    
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
    }
    
    func schedule(noteId: String, title: String, body: String, date: Date) {
        guard date > Date() else { return }
    
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body.isEmpty ? "Пора выполнить задачу" : body
        content.sound = .default
        content.categoryIdentifier = "NOTE_REMINDER"
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: noteId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func cancel(noteId: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [noteId])
    }
    
    func configure() {
        let center = UNUserNotificationCenter.current()
        let complete = UNNotificationAction(identifier: "COMPLETE_NOTE", title: "Задача выполнена", options: [],icon: .init(systemImageName: "checkmark"))
        let snooze = UNNotificationAction(identifier: "SNOOZE_10", title: "Напомнить позже", options: [], icon: .init(systemImageName: "clock"))
        let category = UNNotificationCategory(identifier: "NOTE_REMINDER", actions: [complete,snooze], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func snooze(userId: String, title: String, body:String, minutes: Int) {
        NotificationService.shared.cancel(noteId: userId)
        let newDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        schedule(noteId: userId, title: title, body: body, date: newDate)
    }
}
