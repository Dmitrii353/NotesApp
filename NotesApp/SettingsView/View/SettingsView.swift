//
//  SettingsView.swift
//  NotesApp
//
//  Created by Дима Люфт on 21.10.2026.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    
}

final class SettingsView: UIViewController, SettingsViewProtocol {
    
    var presenter: SettingsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackgroundView
        title = "Настройки"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
