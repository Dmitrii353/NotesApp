//
//  Model.swift
//  NotesApp
//
//  Created by Дима Люфт on 15.11.2026.
//

import Foundation


enum NotesFilter: Int, CaseIterable {
    case all
    case active
    case completed
    case overdue
    case today
    case tomorrow
    case noDate
    
    var title: String {
        switch self {
        case .all:
            "Все"
        case .active:
            "Активные"
        case .completed:
            "Готовые"
        case .overdue:
            "Просроченные"
        case .today:
            "Сегодня"
        case .tomorrow:
            "Завтра"
        case .noDate:
            "Без даты"
        }
    }
}
