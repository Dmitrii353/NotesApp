//
//  Ext.CreateDate.swift
//  m3#8
//
//  Created by Дима Люфт on 04.07.2026.
//

import Foundation

extension Date {
    
    func formatDateForCell() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy"
        
        return formatter.string(from: self)
    }
    
    func formatDateForListNoteView() ->String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
    
    func formatForNoteCell() -> String {
        let calendar = Calendar.current
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        
        if calendar.isDateInToday(self) {
            return "Сегодня, \(time.string(from: self))"
        }
        if calendar.isDateInTomorrow(self) {
            return "Завтра, \(time.string(from: self))"
        }
        
        let day = DateFormatter()
        day.locale = Locale(identifier: "ru_RU")
        day.dateFormat = "d MMM, HH:mm"
        return day.string(from: self)
    }
}
