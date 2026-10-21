//
//  AllNotesView.swift
//  NotesApp
//
//  Created by Дима Люфт on 21.10.2026.
//

import UIKit

protocol AllNotesViewProtocol: AnyObject {
    
}

final class AllNotesView: UIViewController, AllNotesViewProtocol {
   
    var presenter: AllNotesPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colorBackgroundView
        title = "Все заметки"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
}
