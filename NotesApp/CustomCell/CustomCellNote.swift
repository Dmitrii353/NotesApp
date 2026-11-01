//
//  CustomCellNote.swift
//  m3#8
//
//  Created by Дима Люфт on 21.10.2024.
//

import UIKit

class CustomCellNote: UITableViewCell, SetupNewCell {
    static var reuseId: String = "CustomCellNote"
    var onToggle: ((String) -> Void)?
    private var noteId: String?
    
    lazy var addView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 55
        $0.layer.masksToBounds = true
        $0.heightAnchor.constraint(equalToConstant: 145).isActive = true
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 7
        return $0
    }(UIView())
   
    lazy var nameNote: UILabel = AddLabel(fontText: 16, fontW: .bold, colorText: .black,textAlignmentLabel: .left)
    lazy var checkBox: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .colorCheckCircleNote
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    lazy var detailsNote: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel, textAlignmentLabel: .left)

    lazy var deleteNote: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        $0.tintColor = .darkGray
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return $0
    }(UIButton())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
        setupConstraints()
    }
   
   func setupElements() {
    
        contentView.addSubview(addView)
        addView.addSubViews(nameNote,detailsNote,checkBox,deleteNote)
       contentView.backgroundColor = .colorBackgroundView
    }
    
  func setupConstraints() {
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            checkBox.topAnchor.constraint(equalTo: addView.topAnchor,constant: 18),
            checkBox.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            
            nameNote.topAnchor.constraint(equalTo: addView.topAnchor, constant: 16),
            nameNote.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor,constant: 14),
            nameNote.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -60),
            nameNote.heightAnchor.constraint(equalToConstant: 45),
            
            detailsNote.topAnchor.constraint(equalTo: nameNote.bottomAnchor, constant: 4),
            detailsNote.leadingAnchor.constraint(equalTo: nameNote.leadingAnchor),
            detailsNote.trailingAnchor.constraint(equalTo: nameNote.trailingAnchor),
            
            addView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            deleteNote.topAnchor.constraint(equalTo: checkBox.topAnchor),
            deleteNote.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
        ])
    }
    
    func configure(note: Note) {
        noteId = note.id
        nameNote.text = note.name
        detailsNote.text = note.details
        updateCheckBox(isCompleted: note.execution)

    }
    
    @objc
     func checkboxTapped() {
         guard let id = noteId else { return}
         onToggle?(id)
       }
   
    private func updateCheckBox(isCompleted: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        checkBox.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    }
    


