//
//  Builder.swift
//  NotesApp
//
//  Created by Дима Люфт on 18.07.2026.
//

import UIKit

class Builder {
    
    static func createMainTaskView() -> UIViewController {
        let pickerView = CategoryPickerViewController()
        let view = TasksView(categoryPickerView: pickerView)
        let presenter = MainTaskPresenter(view: view)
        view.mainTaskPresenter = presenter
        let navigation = UINavigationController(rootViewController: view)
        return navigation
    }
    
    static func createNoteView(tasks: Tasks?) -> UIViewController {
        let view = NoteView()
        let presenter = ListNotePresenter(view: view, tasks: tasks)
        view.presenter = presenter
        return view
    }
    
    static func createSettingsView() -> UIViewController {
        let view = SettingsView()
        let presenter = SettingsPresenter(view: view)
        view.presenter = presenter
        let navigation = UINavigationController(rootViewController: view)
        return navigation
    }
    
    static func createAllNotesView() -> UIViewController {
        let view = AllNotesView()
        let presenter = AllNotesPresenter(view: view)
        view.presenter = presenter
        let navigation = UINavigationController(rootViewController: view)
        return navigation
    }
    
}
