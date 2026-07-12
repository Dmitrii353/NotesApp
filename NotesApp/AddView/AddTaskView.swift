//
//  AddTaskView.swift
//  m3#8
//
//  Created by Дима Люфт on 22.10.2024.
//

import UIKit

class AddTaskView: UIViewController {

    private var coreManager = CoreManager.shared
    
   private var colorCell: [UIColor] = [.lightBlue,.lighthacky,.lightPurple]
    
    lazy var nameTask: UITextField = {
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
    lazy var detailTask: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .lightGray
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.backgroundColor = .colorBackground
        $0.layer.cornerRadius = 15
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        $0.layer.masksToBounds = false
        return $0
    }(UITextView())
    
    lazy var saveTask: UIButton = {
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
        guard let name = nameTask.text, !name.isEmpty else {
            alertError(title: "Произошла ошибка", message: "Введите название задачи")
            return
        }
        guard let details = detailTask.text, !details.isEmpty else {
            alertError(title: "Произошла ошибка", message: "Введите описание")
            return
        }
            coreManager.createTask(name: name, description: details)
            coreManager.saveContext()
            coreManager.getFolder()
            navigationController?.popViewController(animated: true)
        }
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()

      
    }
    
    private func setupElements() {
        view.backgroundColor = colorCell.randomElement()
        title = "Добавить задачу"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubViews(nameTask,descriptionLabel,detailTask,saveTask)
        descriptionLabel.text = "Краткое описание задачи"
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
           
            nameTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTask.heightAnchor.constraint(equalToConstant: 60),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTask.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameTask.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameTask.trailingAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            detailTask.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            detailTask.leadingAnchor.constraint(equalTo: nameTask.leadingAnchor),
            detailTask.trailingAnchor.constraint(equalTo: nameTask.trailingAnchor),
            detailTask.heightAnchor.constraint(equalToConstant: 250),
            
            saveTask.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveTask.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
    
    private func alertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    

}
