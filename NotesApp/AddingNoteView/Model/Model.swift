//
//  Model.swift
//  NotesApp
//
//  Created by Дима Люфт on 08.11.2026.
//

import UIKit

enum NotePriority: String,CaseIterable {
    case notSelected = "Not selected"
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    
    var title: String {
        switch self {
        case .notSelected:
            return "Не выбран"
        case .low:
            return "Низкий"
        case .medium:
            return "Средний"
        case .high:
            return "Высокий"
        }
    }
    
    var color: UIColor {
        switch self {
        case .low:
            return .colorIdeaIcon
        case .medium:
            return .colorProductsIcon
        case .high:
            return .colorHealthIcon
        case .notSelected:
            return .colorDescriptionLabel
        }
    }

    static func from(_ raw: String?) -> NotePriority {
        NotePriority(rawValue: raw ?? "") ?? .notSelected
    }
}
