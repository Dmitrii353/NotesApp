//
//  AllNotesPresenter.swift
//  NotesApp
//
//  Created by Дима Люфт on 22.10.2026.
//

import Foundation

protocol AllNotesPresenterProtocol: AnyObject {
    func filterTitle(for filter: NotesFilter) -> String
    func updateAllNotes()
    func selectFilter(filter: NotesFilter)
    var selectedFilter: NotesFilter { get }
}

final class AllNotesPresenter: AllNotesPresenterProtocol {
   private var allNotes: [Note] = []
    private let coreManager = CoreManager.shared
    weak var view: AllNotesViewProtocol?
    private(set) var selectedFilter: NotesFilter = .all
    init(view: AllNotesViewProtocol?) {
        self.view = view
    }
    
    func updateAllNotes() {
        fetchNotes()
        view?.reloadData()
    }
    
    private func fetchNotes() {
        coreManager.getFolder()
        
        allNotes = coreManager.tasks.flatMap{ task -> [Note] in
            (task.notes?.allObjects as? [Note]) ?? []
            
        } .sorted { lrs, rhs in
            let left = lrs.dueDate ?? .distantFuture
            let right = rhs.dueDate ?? .distantFuture
            return left < right
        }
    }
    
    
    private func notes(for filter: NotesFilter) -> [Note] {
        let calendar = Calendar.current
        let now = Date()
        switch filter {
        case .all:
            return allNotes
        case .active:
            return allNotes.filter{ !$0.execution }
        case .completed:
            return allNotes.filter{ $0.execution }
        case .overdue:
            return allNotes.filter{ note in
                guard let due = note.dueDate else { return false }
                return due < now && !calendar.isDateInToday(due) && !note.execution
            }
        case .today:
            return allNotes.filter{ note in
                guard let due = note.dueDate else { return false }
                return calendar.isDateInToday(due)
            }
        case .tomorrow:
            return allNotes.filter{ note in
                guard let due = note.dueDate else { return false }
                return calendar.isDateInTomorrow(due)
            }
        case .noDate:
            return allNotes.filter{$0.dueDate == nil}
        }
    }

    
    func categoryName(for note: Note) -> String {
        return note.tasks?.name ?? "Без категории"
    }
    
    func filterTitle(for filter: NotesFilter) -> String {
        return "\(filter.title) · \(notes(for: filter).count)"
    }
    
    func selectFilter(filter: NotesFilter) {
        selectedFilter = filter
        view?.reloadData()
    }
}
