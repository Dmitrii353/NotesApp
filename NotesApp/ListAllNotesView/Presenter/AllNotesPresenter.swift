//
//  AllNotesPresenter.swift
//  NotesApp
//
//  Created by Дима Люфт on 22.10.2026.
//

import Foundation

protocol AllNotesPresenterProtocol: AnyObject {
    
}

final class AllNotesPresenter: AllNotesPresenterProtocol {
    
    weak var view: AllNotesViewProtocol?
    
    init(view: AllNotesViewProtocol?) {
        self.view = view
    }
}
