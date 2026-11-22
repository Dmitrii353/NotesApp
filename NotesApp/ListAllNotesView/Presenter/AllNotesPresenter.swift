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
    var allNotes: [Note] {get set}
    var displayedNotes: [Note] {get}
    func toggleNote(with id: String)
    func sortingNotesByPriority()
    func updateSearchText(_ text: String)
}

final class AllNotesPresenter: AllNotesPresenterProtocol {
    private var searchText: String = ""
    var allNotes: [Note] = []
    private let coreManager = CoreManager.shared
    private var isPrioritydescending = true
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
                return due < now && !note.execution
            }
        case .today:
            return allNotes.filter{ note in
                guard let due = note.dueDate else { return false }
                return due > now && calendar.isDateInToday(due) && !note.execution
            }
        case .tomorrow:
            return allNotes.filter{ note in
                guard let due = note.dueDate else { return false }
                return calendar.isDateInTomorrow(due) && !note.execution
            }
        case .noDate:
            return allNotes.filter{$0.dueDate == nil && !$0.execution}
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
    
    func toggleNote(with id: String) {
        guard let note = allNotes.first(where: { $0.id == id }) else { return }
        note.execution.toggle()
        coreManager.saveContext()
        
        if note.execution {
            NotificationService.shared.cancel(noteId: id)
        }
        updateAllNotes()
    }
    
    func updateSearchText(_ text: String) {
        searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        view?.reloadData()
    }
    
    func sortingNotesByPriority() {
        isPrioritydescending.toggle()
        view?.reloadData()
    }
    
    private func priorityWeight(_ raw: String? ) -> Int {
            switch NotePriority.from(raw ?? "") {
            case .low:
                return 1
            case .medium:
                return 2
            case .high:
                return 3
            case .notSelected:
                return 0
            }
        }
    
    var displayedNotes: [Note] {
      var result = notes(for: selectedFilter)
        
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter{ note in
                let name = note.name?.lowercased() ?? ""
                let category = categoryName(for: note).lowercased()
                return name.contains(query) || category.contains(query)
            }
        }
        return result.sorted { lrs, hrs in
            let l = priorityWeight(lrs.priority)
            let r = priorityWeight(hrs.priority)
            return isPrioritydescending ? (l > r) : (l < r)
        }
    }

}
