//
//  AddNotePresenter.swift
//  NotesApp
//
//  Created by Дима Люфт on 18.07.2026.
//

import Foundation

protocol AddNotePresenterProtocol: AnyObject {
    func createNewNote(title: String, details: String, dueDate: Date?)
}

final class AddNotePresenter: AddNotePresenterProtocol{
    
    weak var view: AddNoteViewProtocol?
    private var coreManager = CoreManager.shared
    var tasks: Tasks?

    init(view: AddNoteViewProtocol?, tasks: Tasks?) {
        self.view = view
        self.tasks = tasks
        
    }

    
    func createNewNote(title: String, details: String, dueDate: Date?) {
        guard let selectedPriority = view?.selectedPriority else { return }
        coreManager.createNote(task: tasks, name: title, details: details, priority: selectedPriority, dueDate: dueDate)
            coreManager.saveContext()
            coreManager.getFolder()
    }
}
