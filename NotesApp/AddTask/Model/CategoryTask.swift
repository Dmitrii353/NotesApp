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
            return "briefcase"
        case "Учёба":
            return "book"
        case "Продукты":
            return "cart"
        case "Личное": 
            return "person"
        case "Здоровье":
            return "heart"
        case "Покупки": 
            return "gym.bag"
        case "Хобби":
            return "duffle.bag"
        case "Цели":
            return "pencil"
        case "Дом":
            return "house"
        case "Другое":
            return "ellipsis.circle"
        case "Идеи":
            return "lightbulb"
        default:
            return "folder"
        }
    }
    
    static func color(for nameCategory: String) -> UIColor {
        switch nameCategory {
    case "Работа":
        return .colorJob
    case "Учёба":
        return .colorStudy
    case "Продукты":
        return .colorProducts
    case "Личное":
        return .colorPersonal
    case "Здоровье":
        return .colorHealth
    case "Покупки":
        return .colorShop
    case "Хобби":
        return .colorHobby
    case "Цели":
        return .colorGoals
    case "Дом":
        return .colorHouse
    case "Другое":
        return .colorOther
    case "Идеи":
        return .lightYellow
    default:
        return .systemGray
            }
        }
    
    static func colorIcon(for nameCategory: String) -> UIColor {
        switch nameCategory {
    case "Работа":
        return .colorJobIcon
    case "Учёба":
        return .colorStudyIcon
    case "Продукты":
        return .colorProductsIcon
    case "Личное":
        return .colorPersonalIcon
    case "Здоровье":
        return .colorHealthIcon
    case "Покупки":
        return .colorShopIcon
    case "Хобби":
        return .colorHobbyIcon
    case "Цели":
        return .colorGoalsIcon
    case "Дом":
        return .colorHouseIcon
    case "Другое":
        return .colorOtherIcon
    case "Идеи":
            return .colorIdeaIcon
    default:
        return .systemGray
            }
        }
}

