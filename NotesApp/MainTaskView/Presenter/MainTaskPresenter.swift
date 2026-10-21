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
    func generatingMotivationPhrases() -> String
    func countOfCompletedTasks() -> String
    func countProgressAllNotes() -> Float
    var notes: [Note] { get }
}

class MainTaskPresenter: MainTaskPresenterProtocol {
    
    weak var view: TaskViewProtocol?
    var tasks : [Tasks] = []
    var notes: [Note] = []
    private let coreManager = CoreManager.shared
   // private let taskModel: [TaskModel] = TaskModel.mockPhrases()
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
        updateUpcomingNotes()
        view?.reloadData()
    }
    
    func generatingMotivationPhrases() -> String {
        return TaskModel.mockPhrases().randomElement()?.phrases.description ?? "Ты все сможешь"
    }
    
    func countProgressAllNotes() -> Float {
        let countNotes = tasks.flatMap { task -> [Note] in
            (task.notes?.allObjects as? [Note]) ?? []
        }
        guard !countNotes.isEmpty else { return 0 }
        let completedCount = countNotes.filter {$0.execution}.count
        return  Float(completedCount) / Float(countNotes.count)
    }
    
    func countOfCompletedTasks() -> String {
        let allNotes = tasks.flatMap { task -> [Note] in
            (task.notes?.allObjects as? [Note]) ?? []
        }
       guard !allNotes.isEmpty else { return "Нет задач"}
        let completed = allNotes.filter {$0.execution}.count
        return "\(completed) из \(allNotes.count)"
    }
    
    func updateUpcomingNotes() {
        let allNotes = tasks.flatMap { task -> [Note] in
            (task.notes?.allObjects as? [Note] ?? [])
        }
        notes = allNotes.filter{ note in
            guard let name = note.name else { return false}
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        .sorted {($0.tasks?.date ?? Date.distantPast) > ($1.tasks?.date ?? Date.distantPast)}
    }
}

