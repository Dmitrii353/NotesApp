//
//  TaskModel.swift
//  NotesApp
//
//  Created by Дима Люфт on 07.10.2026.
//

import Foundation


struct TaskModel {
   
    let phrases: String
    
   static func mockPhrases() -> [TaskModel] {
        [
                  TaskModel(phrases: "Ещё чуть-чуть — и всё будет готово"),
                  TaskModel(phrases: "Ещё мгновение — и делам конец"),
                  TaskModel(phrases: "Ещё немного усилий — и всё сделано"),
                  TaskModel(phrases: "Последний рывок — и всё закрыто"),
                  TaskModel(phrases: "Финишная прямая — ещё немного"),
                  TaskModel(phrases: "Почти у цели,Осталось чуть-чуть")
        ]
    }
}
