//
//  OneNoteView.swift
//  m3#8
//
//  Created by Дима Люфт on 25.10.2024.
//

import UIKit

class OneNoteView: UIViewController {
   
    var tasks: Tasks?
    private var coreManager = CoreManager.shared
    var selectedNoteIndex: Int?
    private var colorCell: [UIColor] = [.lightBlue,.lighthacky,.lightPurple]
    lazy var titleNote: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Название"
        $0.font = .systemFont(ofSize: 20, weight: .black)
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
    lazy var detailsNote: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.tintColor = .lightGray
        $0.layer.masksToBounds = false
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 15
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        return $0
    }(UITextView())
   private lazy var updateButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .customRed
        $0.setTitle("Обновить заметку", for: .normal)
        $0.tintColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowRadius = 7
        $0.layer.shadowOpacity = 0.5
        return $0
    }(UIButton(primaryAction: updateAction))
    
    private lazy var updateAction: UIAction = UIAction { [weak self] _ in
        guard let self = self else { return }
        showAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    private func setupElements() {
        view.backgroundColor = colorCell.randomElement()
        view.addSubViews(titleNote,detailsNote,updateButton)
        title = titleNote.text
        navigationController?.navigationBar.prefersLargeTitles = true
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            titleNote.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            titleNote.heightAnchor.constraint(equalToConstant: 40),
            
            detailsNote.topAnchor.constraint(equalTo: titleNote.bottomAnchor, constant: 40),
            detailsNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            detailsNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            detailsNote.heightAnchor.constraint(equalToConstant: 250),
            
            updateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            updateButton.heightAnchor.constraint(equalToConstant: 60),
            
            
            ])
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Предупреждение", message: "Вы действительно хотите обновить заметку?", preferredStyle: .alert)
       
        let SuccessAction = UIAlertAction(title: "Da", style: .default) { (action) in
            print("пользователь выбрал *Да*")
            self.redactingTitleNote()
            self.redactingdetailsNote()
            self.navigationController?.popViewController(animated: true)
        }
          
                let cancelAction = UIAlertAction(title: "Net", style: .cancel) { (action) in
                    print("пользователь выбрал *Нет*")
                    self.answerPersonFalse()
           
                    self.navigationController?.popViewController(animated: true)
                }
            alert.addAction(SuccessAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
           
        }
       
    private func redactingTitleNote() {
        if let note = tasks?.notes?.allObjects as? [Note], let index = selectedNoteIndex {
            guard index < note.count else { return }
            let noteToEdit = note[index]
            guard let title = titleNote.text,  title != noteToEdit.name else {
                print("Название одинаковое")
                return
            }
            noteToEdit.name = title
            coreManager.saveContext()
            coreManager.getFolder()
        }
    }
          
        private func redactingdetailsNote() {
            if let note = tasks?.notes?.allObjects as? [Note], let index = selectedNoteIndex {
                guard index < note.count else { return }
                let noteToEdit = note[index]
                guard let details = detailsNote.text, details != noteToEdit.details else {
                    print("Описание одинаковое")
                    return
                }
                noteToEdit.details = details
                coreManager.saveContext()
                coreManager.getFolder()
            }
        }
     
    private func answerPersonFalse() {
    }

}
