//
//  CustomCellNote.swift
//  m3#8
//
//  Created by Дима Люфт on 21.10.2024.
//

import UIKit

class CustomCellNote: UITableViewCell, SetupNewCell {
    static var reuseId: String = "CustomCellNote"
    var note: Note?
    var coreManager = CoreManager.shared
    
   private var colorCell: [UIColor] = [.lightBlue,.lighthacky,.lightPink,.lightPurple]
    lazy var addView:UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = colorCell.randomElement()
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        $0.layer.masksToBounds = false
        return $0
    }(UIView())
   
    lazy var nameNote: UILabel = AddLabel(fontText: 16, fontW: .bold, colorText: .black)
    lazy var checkBox: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .lightGrey
        $0.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    lazy var detailsNote: UILabel = AddLabel(fontText: 14, fontW: .medium, colorText: .black)
    lazy var imageNote: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 45
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 15, height: 15)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        return $0
    }(UIImageView())

    lazy var deleteNote: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        $0.tintColor = .darkGray
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return $0
    }(UIButton())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
        setupConstraints()
    }
   
   func setupElements(){
    
        contentView.addSubview(addView)
        addView.addSubViews(nameNote,imageNote,detailsNote,checkBox,deleteNote)
       contentView.backgroundColor = .colorCollection
    }
    
  func setupConstraints(){
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            addView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            nameNote.topAnchor.constraint(equalTo: addView.topAnchor, constant: 25),
            nameNote.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            nameNote.heightAnchor.constraint(equalToConstant: 25),
            
            checkBox.topAnchor.constraint(equalTo: addView.topAnchor,constant: 15),
            checkBox.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -25),
            checkBox.widthAnchor.constraint(equalToConstant: 50),
            checkBox.heightAnchor.constraint(equalToConstant: 50),
            
            imageNote.topAnchor.constraint(equalTo: nameNote.topAnchor, constant: 30),
            imageNote.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            imageNote.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
            imageNote.heightAnchor.constraint(equalToConstant:  180),
            
            detailsNote.topAnchor.constraint(equalTo: imageNote.bottomAnchor, constant: 25),
            detailsNote.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            detailsNote.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
            
            detailsNote.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -40),
            addView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            
            deleteNote.topAnchor.constraint(equalTo: checkBox.topAnchor),
            deleteNote.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 25),
        ])
    }
    
    func configure(note: Note) {
        self.note = note
        checkToggle()
    }
    @objc
     func checkboxTapped() {
         guard let subtask = note else { return }
         subtask.execution.toggle() // переключение статуса выполнения
         coreManager.toggleCheckBox(note: subtask) // в Core Data
         checkToggle() // Обновляем
       }
   
    private func checkToggle() {
        if  note?.execution == true {
                    checkBox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                } else {
                    checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    }
    


