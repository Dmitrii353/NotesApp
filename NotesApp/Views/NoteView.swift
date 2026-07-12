//
//  NoteView.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

class NoteView: UIViewController {

    private let coreManager = CoreManager.shared
    var tasks: Tasks?
   
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
        coreManager.getFolder()
        self.noteTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noteTableView)
        view.backgroundColor = .colorCollection
        title = "Заметки"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem( image: UIImage(systemName: "plus.app"), style: .done, target: self, action: #selector(addNote))
        setupConstraints()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
    
    
    @objc
    func addNote(){
        let Addnote = AddNoteView()
        Addnote.tasks = tasks
        navigationController?.pushViewController(Addnote, animated: true)
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
        tasks?.notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = noteTableView.dequeueReusableCell(withIdentifier: CustomCellNote.reuseId, for: indexPath) as! CustomCellNote
        if let notes = tasks?.notes?.allObjects as? [Note] {
            let note = notes[indexPath.row]
            if let imageName = note.photo, let data = coreManager.readFile(imageName: imageName), let image = UIImage(data: data) {
                cell.imageNote.image = image.circularImage()
            } else {
                cell.imageNote.image = UIImage(systemName: "plus.circle")
            }
            cell.nameNote.text = note.name
            cell.detailsNote.text = note.details
            cell.configure(note: note)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oneNote = OneNoteView()
        if let notes = tasks?.notes?.allObjects as? [Note] {
            let note = notes[indexPath.row]
            oneNote.selectedNoteIndex = indexPath.row
            oneNote.titleNote.text = note.name
            oneNote.detailsNote.text = note.details
            
            oneNote.tasks = tasks
        }
        navigationController?.pushViewController(oneNote, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let notes = tasks?.notes?.allObjects as? [Note] {
                let note = notes[indexPath.row]
                coreManager.deleteNote(note: note)
                coreManager.saveContext()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
        }
    }
}
extension UIImage {
    func circularImage() -> UIImage? {
        let diameter = min(size.width, size.height)
        let rect = CGRect(x: (size.width - diameter) / 2, y: (size.height - diameter) / 2, width: diameter, height: diameter)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0.0)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        path.addClip()
        draw(in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: size.width, height: size.height))
        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circularImage
    }
}
