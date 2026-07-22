//
//  ListNotePresenter.swift
//  NotesApp
//
//  Created by Дима Люфт on 18.07.2026.
//

import Foundation

protocol ListNotePresenterProtocol: AnyObject {
    var tasks: Tasks? { get set }
    func updateNotes()
    func getNoteViewModel(at index: Int) -> NoteViewModel?
    func deleteNote(with id: String)
}

class ListNotePresenter: ListNotePresenterProtocol {
    
    weak var view: NoteViewProtocol?
    private let coreManager = CoreManager.shared
    var tasks: Tasks?
    private var noteViewModel: [NoteViewModel] = []
    init(view: NoteViewProtocol?, tasks: Tasks?) {
        self.view = view
        self.tasks = tasks
    }
    
    func updateNotes() {
        coreManager.getFolder()
        view?.reloadData()
    }
    
    func getNoteViewModel(at index: Int) -> NoteViewModel? {
            guard index >= 0 && index < noteViewModel.count else { return nil }
            return noteViewModel[index]
        }
    
    private func buildViewModel() {
        guard let notes = tasks?.notes?.allObjects as? [Note] else {
            noteViewModel = []
            return
        }
        noteViewModel = notes.map { note in
            NoteViewModel(id: note.id,
                          name: note.name,
                          details: note.details,
                          image: note.photo)
        }
    }
    
     func deleteNote(with id: String) {
         guard var noteToDelete = tasks?.notes?.allObjects as? [Note], let index = noteToDelete.first(where: {$0.id == id}) else {
             view?.showError(message: "Ошибка удаления заметки")
             return
         }
         coreManager.deleteNote(note: index)
         coreManager.saveContext()
         
         noteToDelete.removeAll{ $0.id == id }
         
         view?.deleteNote(at: id)
         buildViewModel()
         view?.reloadData()
    }
}
