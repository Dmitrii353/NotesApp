//
//  SettingsPresenter.swift
//  NotesApp
//
//  Created by Дима Люфт on 22.10.2026.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    
}

final class SettingsPresenter: SettingsPresenterProtocol {
    
    weak var view: SettingsViewProtocol?
    
    init(view: SettingsViewProtocol?) {
        self.view = view
    }
}
