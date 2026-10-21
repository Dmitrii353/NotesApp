//
//  TabBarView.swift
//  NotesApp
//
//  Created by Дима Люфт on 21.10.2026.
//

import UIKit

class TabBarView: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.tintColor = .colorButton
        tabBar.backgroundColor = .colorTabBar
    }
    
    private func setupTabBar() {
        let category = settingElementTab(view: Builder.createMainTaskView(), title: "Категории", image: "square.grid.2x2", selectedImage: "square.grid.2x2.fill")
        let allNotes = settingElementTab(view: Builder.createAllNotesView(), title: "Все заметки", image: "list.bullet.rectangle", selectedImage: "list.bullet.rectangle.fill")
        let settingsView = settingElementTab(view: Builder.createSettingsView(), title: "Настройки", image: "gearshape", selectedImage: "gearshape.fill")
        
        setViewControllers([category,allNotes,settingsView], animated: true)
    }
    
    
    private func settingElementTab(view: UIViewController,title: String, image: String, selectedImage: String) -> UIViewController {
        view.tabBarItem.title = title
        view.tabBarItem.image = UIImage(systemName: image)
        view.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        return view
    }
}
