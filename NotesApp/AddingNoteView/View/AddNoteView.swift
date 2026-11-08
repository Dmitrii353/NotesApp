//
//  AddNoteView.swift
//  m3#8
//
//  Created by Дима Люфт on 24.10.2024.
//

import UIKit

class AddNoteView: UIViewController {

    var tasks: Tasks?
    private var coreManager = CoreManager.shared
    
    lazy var nameNote: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Название"
        $0.tintColor = .lightGray
        let indent: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.leftView = indent
        $0.leftViewMode = .always
        $0.rightView = indent
        $0.rightViewMode = .always
        $0.backgroundColor = .colorBackground
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        return $0
    }(UITextField())
    
    lazy var descriptionLabel: UILabel = AddLabel(fontText: 18, fontW: .bold, colorText: .black)
    
    lazy var detailNote: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.tintColor = .lightGray
        $0.layer.masksToBounds = false
        $0.backgroundColor = .colorBackground
        $0.layer.cornerRadius = 15
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        return $0
    }(UITextView())
    
    lazy var priorityControl: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.12
        $0.layer.shadowRadius = 4
        $0.selectedSegmentIndex = 0
        return $0
    }(UISegmentedControl(items: NotePriority.allCases.map(\.title)))
    
    var selectedPriority: NotePriority {
        NotePriority.allCases[priorityControl.selectedSegmentIndex]
    }
    
    lazy var saveNote: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.tintColor = .white
        $0.setTitle("Добавить", for: .normal)
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        return $0
    }(UIButton(primaryAction: saveDataAction))
    lazy var saveDataAction: UIAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        guard let name = nameNote.text, !name.isEmpty else {
            alertError(title: "Произошла ошибка", message: "Введите название")
            return
        }
        guard let details = detailNote.text, !details.isEmpty else {
            alertError(title: "Произошла ошибка", message: "Введите описание")
            return
        }
        let imageName = "\(UUID().uuidString).jpg"
        coreManager.createNote(task: tasks, name: name, image: imageName, details: details,priority: selectedPriority )
            coreManager.saveContext()
            coreManager.getFolder()
            navigationController?.popViewController(animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
 
      
    }
    
    private func setupElements() {
        view.backgroundColor = .white
        title = "Добавить заметку"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubViews(nameNote,descriptionLabel,detailNote,saveNote,priorityControl)
        descriptionLabel.text = "Краткое описание заметки"
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
           
            priorityControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priorityControl.heightAnchor.constraint(equalToConstant: 45),
            priorityControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
           
            nameNote.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20),
            nameNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameNote.heightAnchor.constraint(equalToConstant: 60),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: detailNote.topAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameNote.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameNote.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            detailNote.bottomAnchor.constraint(equalTo: saveNote.topAnchor, constant: -40),
            detailNote.leadingAnchor.constraint(equalTo: nameNote.leadingAnchor),
            detailNote.trailingAnchor.constraint(equalTo: nameNote.trailingAnchor),
            detailNote.heightAnchor.constraint(equalToConstant: 250),
            
            saveNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveNote.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
    
    private func alertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}




