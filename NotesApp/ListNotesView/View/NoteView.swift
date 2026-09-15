//
//  NoteView.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

protocol NoteViewProtocol: AnyObject {
    func reloadData()
    func deleteNote(at id: String)
    func showError(message: String)
}

class NoteView: UIViewController, NoteViewProtocol {
    
    var presenter: ListNotePresenterProtocol!
    private let imageService: ImageServiceProtocol = ImageService()
    lazy var noteTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .colorCollection
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.register(CustomCellNote.self, forCellReuseIdentifier: CustomCellNote.reuseId )
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.updateNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noteTableView)
        view.backgroundColor = .colorCollection
        title = presenter.tasks?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem( image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addNote))
        setupConstraints()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
    
    func reloadData() {
        noteTableView.reloadData()
    }
    
    func deleteNote(at id: String) {
        let index = presenter.tasks?.notes?.allObjects as! [Note]
        guard let noteId = index.firstIndex(where: {$0.id == id}) else {
            reloadData()
            return
        }
        let indexPath = IndexPath(row: noteId, section: 0)
        noteTableView.performBatchUpdates {
            noteTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc
    func addNote(){
        let Addnote = AddNoteView()
        Addnote.tasks = presenter.tasks
        navigationController?.pushViewController(Addnote, animated: true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Окей", style: .cancel))
        present(alert,animated: true)
    }
    
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            noteTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            
        ])
    }
    
    
}

extension NoteView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tasks?.notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: CustomCellNote.reuseId, for: indexPath) as! CustomCellNote
        if let notes = presenter.tasks?.notes?.allObjects as? [Note] {
            let note = notes[indexPath.row]
            if let image = note.photo {
                cell.imageNote.image = imageService.loadImage(name: image)
            } else {
                 cell.imageNote.image = UIImage(systemName: "photo")
            }
            cell.nameNote.text = note.name
            cell.detailsNote.text = note.details
            cell.configure(note: note)
            cell.deleteNote.tag = indexPath.row
            cell.deleteNote.addTarget(self, action: #selector(deleteNoteTapped), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneNote = OneNoteView()
        if let notes = presenter.tasks?.notes?.allObjects as? [Note] {
            let note = notes[indexPath.row]
            oneNote.selectedNoteIndex = indexPath.row
            oneNote.titleNote.text = note.name
            oneNote.detailsNote.text = note.details
            
            oneNote.tasks = presenter.tasks
        }
        navigationController?.pushViewController(oneNote, animated: true)
    }
    
    @objc private func deleteNoteTapped(_ sender: UIButton) {
        let index = sender.tag
        let notes = presenter.tasks?.notes?.allObjects as? [Note]
        guard index < notes?.count ?? 0 else { return }
        let oneNote = notes?[index]
        if let noteId = oneNote?.id {
            presenter.deleteNote(with: noteId)
        }
    }
}

