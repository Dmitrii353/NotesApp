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
}
