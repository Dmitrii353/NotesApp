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
   private var colorCell: [UIColor] = [.lightBlue,.lighthacky,.lightPurple]
    
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
    lazy var imageNote: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 80
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleAspectFill
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
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
        guard let image = imageNote.image, let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imageName = "\(UUID().uuidString).jpg"
        coreManager.saveFile(file: imageData, imageName: imageName)
        coreManager.createNote(task: tasks, name: name, image: imageName, details: details)
            coreManager.saveContext()
            coreManager.getFolder()
            navigationController?.popViewController(animated: true)
        }
    lazy var imagePicker: UIImagePickerController = {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        $0.delegate = self
        return $0
    }(UIImagePickerController())
    
    @objc
    func imageTapped() {
        present(imagePicker, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
 
      
    }
    
    private func setupElements() {
        view.backgroundColor = colorCell.randomElement()
        title = "Добавить заметку"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubViews(nameNote,imageNote,descriptionLabel,detailNote,saveNote)
        descriptionLabel.text = "Краткое описание заметки"
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
           
            imageNote.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageNote.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageNote.widthAnchor.constraint(equalToConstant: 160),
            imageNote.heightAnchor.constraint(equalToConstant: 160),
           
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

extension AddNoteView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageNote.image = image
           
            }
        
        picker.dismiss(animated: true)
    }
}



