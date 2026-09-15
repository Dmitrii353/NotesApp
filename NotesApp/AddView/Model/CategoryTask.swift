//
//  CategoryTask.swift
//  NotesApp
//
//  Created by Дима Люфт on 13.09.2026.
//

import UIKit

struct CategoryTask {
 
    static let allCategories: [String] = [ "Работа","Учёба","Продукты","Личное","Здоровье","Покупки","Хобби","Цели","Дом","Другое","Идеи"]
    
    
    static func icon(for nameCategory: String) -> String {
        switch nameCategory {
        case "Работа":
            return "handbag"
        case "Учёба":
            return "book.fill"
        case "Продукты":
            return "cart.fill"
        case "Личное": 
            return "person.fill"
        case "Здоровье":
            return "heart.fill"
        case "Покупки": 
            return "gym.bag"
        case "Хобби":
            return "duffle.bag"
        case "Цели":
            return "pencil"
        case "Дом":
            return "house.fill"
        case "Другое":
            return "ellipsis.circle.fill"
        case "Идеи":
            return "lightbulb.fill"
        default:
            return "folder.fill"
        }
    }
    
    static func color(for nameCategory: String) -> UIColor {
        switch nameCategory {
    case "Работа":
        return .systemBlue
    case "Учёба":
        return .systemIndigo
    case "Продукты":
        return .systemOrange
    case "Личное":
        return .systemPurple
    case "Здоровье":
        return .systemPink
    case "Покупки":
        return .systemGreen
    case "Хобби":
        return .systemCyan
    case "Цели":
        return .systemPurple
    case "Дом":
        return .systemTeal
    case "Другое":
        return .systemGray
    case "Идеи":
        return .systemYellow
    default:
        return .systemGray
            }
        }
}

