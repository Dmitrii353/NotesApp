//
//  MainTaskPresenter.swift
//  NotesApp
//
//  Created by Дима Люфт on 18.07.2026.
//

import Foundation

protocol MainTaskPresenterProtocol: AnyObject  {
    var tasks : [Tasks] { get }
    func updateCollectionCoreManager()
    func createNewTaskCoreManager(_ category: String)
    func deleteTask(with id: String)
}

class MainTaskPresenter: MainTaskPresenterProtocol {
    
    weak var view: TaskViewProtocol?
    var tasks : [Tasks] = []
    private let coreManager = CoreManager.shared
    
    init(view: TaskViewProtocol?) {
        self.view = view
    }
    
    func createNewTaskCoreManager(_ category: String) {
        coreManager.createTask(name: category)
        coreManager.saveContext()
        updateCollectionCoreManager()
        view?.createNewTask("Задача \(category) создана")
    }
    
    func deleteTask(with id: String) {
        if let taskToDelete = tasks.first(where: {$0.id == id }) {
            coreManager.deleteTask(task: taskToDelete)
        }
        tasks.removeAll { $0.id == id }
        view?.deleteItem(at: id)
        updateCollectionCoreManager()
    }
    
    func updateCollectionCoreManager() {
        coreManager.getFolder()
        self.tasks = coreManager.tasks
        view?.reloadData()
    }
}

