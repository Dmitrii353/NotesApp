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
    func installCountNotes() -> String
    func installElementDateCreationTask() -> String
    func countOfCompletedNotesString() -> String
    func countActiveNotesString() -> String
    var activeNotes: [Note] { get set }
    var completedNote: [Note] { get set }
    var countOfCompletedNotes: Int { get }
    var countActiveNotes: Int { get }
    func toggleNote(with id: String)
}

class ListNotePresenter: ListNotePresenterProtocol {
    
    weak var view: NoteViewProtocol?
    private let coreManager = CoreManager.shared
    var activeNotes: [Note] = []
    var completedNote: [Note] = []
    var tasks: Tasks?
    private var noteViewModel: [NoteViewModel] = []
    init(view: NoteViewProtocol?, tasks: Tasks?) {
        self.view = view
        self.tasks = tasks
    }
    
    func updateNotes() {
        let countNotes = (tasks?.notes?.allObjects as? [Note]) ?? []
        activeNotes = countNotes.filter{!$0.execution}
        completedNote = countNotes.filter{$0.execution}
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
    
    func installElementDateCreationTask() -> String {
        guard let date = tasks?.date?.formatDateForListNoteView() else { return "нет даты" }
        return date
    }
    
    func countActiveNotesString() -> String {
        let countNotes = (tasks?.notes?.allObjects as? [Note]) ?? []
        let activeCount = countNotes.filter {!$0.execution}.count
        switch activeCount {
        case 0:
            return "0 активных"
        case 1:
            return "1 активная"
        case 2...4:
            return "\(activeCount) активных"
        default:
            return "\(activeCount) активных"
        }
    }
    
    var countActiveNotes: Int {
        activeNotes.count
    }
    
    var countOfCompletedNotes: Int {
        completedNote.count
    }
    
    func countOfCompletedNotesString() -> String {
        let countNotes = (tasks?.notes?.allObjects as? [Note]) ?? []
        let completed = countNotes.filter({$0.execution}).count
        return "\(completed) из \(countNotes.count) выполнено"
    }
    
    func installCountNotes() -> String {
        guard let countNote = tasks?.notes?.allObjects as? [Note] else { return "0 заметок"}
        let countRandom = 2...4
        if countNote.count == 1 {
            return "\(countNote.count) заметка"
        } else if countNote.count == countRandom.randomElement() {
            return "\(countNote.count) заметки"
        }else if countNote.count >= 5 {
            return "\(countNote.count) заметок"
        } else if countNote.count == 0 {
            return "\(countNote.count) заметок"
        } else {
            return "\(countNote.count) заметки"
        }
    }
    
    func toggleNote(with id: String) {
        guard let notes = tasks?.notes?.allObjects as? [Note],
              let note = notes.first(where: { $0.id == id }) else { return }
        note.execution.toggle()
        coreManager.saveContext()
        updateNotes() // пересобирает activeNotes / completedNotes
        view?.reloadData()
    }
}
