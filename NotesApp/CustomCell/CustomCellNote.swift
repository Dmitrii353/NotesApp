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
    var onDelete: ((String) -> Void)?
    
    lazy var addView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        return $0
    }(UIView())
   // MARK: - StackView с отображением приоритета заметки
    lazy var priorityStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addArrangesViews(priorityIconImage,priorityNoteLabel)
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fill
        return $0
    }(UIStackView())
    lazy var priorityNoteLabel: UILabel = AddLabel(fontText: 12, fontW: .medium)
    lazy var priorityIconImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "flag")
        $0.contentMode = .scaleAspectFit
        $0.heightAnchor.constraint(equalToConstant: 14).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 14).isActive = true
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UIImageView())
    // MARK: - StackView c отображением напоминания указанного времени
    lazy var dueDateStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addArrangesViews(dateIconImage,dateLabel)
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        $0.alignment = .center
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fill
        return $0
    }(UIStackView())
    
    lazy var dateLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel)
    lazy var dateIconImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "calendar")
        $0.contentMode = .scaleAspectFit
        $0.heightAnchor.constraint(equalToConstant: 14).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 14).isActive = true
        $0.tintColor = .colorDescriptionLabel
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        return $0
    }(UIImageView())
    
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
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
        $0.setImage(UIImage(systemName: "xmark.app", withConfiguration: config), for: .normal)
        $0.tintColor = .colorDescriptionLabel
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.addTarget(self, action: #selector(deleteNoteTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
        setupConstraints()
    }
   
   func setupElements() {
        contentView.addSubview(addView)
        addView.addSubViews(nameNote,detailsNote,checkBox,deleteNote,priorityStackView,dueDateStackView)
       contentView.backgroundColor = .colorBackgroundView
       nameNote.numberOfLines = 0
       nameNote.lineBreakMode = .byWordWrapping
       detailsNote.numberOfLines = 2
       detailsNote.lineBreakMode = .byTruncatingTail
       dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
       priorityNoteLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
  func setupConstraints() {
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            checkBox.topAnchor.constraint(equalTo: addView.topAnchor,constant: 18),
            checkBox.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            
            deleteNote.topAnchor.constraint(equalTo: checkBox.topAnchor),
            deleteNote.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
            
            nameNote.topAnchor.constraint(equalTo: addView.topAnchor,constant: 8),
            nameNote.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor,constant: 14),
            nameNote.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -55),
            
            detailsNote.topAnchor.constraint(equalTo: nameNote.bottomAnchor, constant: 4),
            detailsNote.leadingAnchor.constraint(equalTo: nameNote.leadingAnchor),
            detailsNote.trailingAnchor.constraint(equalTo: nameNote.trailingAnchor),

            dueDateStackView.topAnchor.constraint(equalTo: priorityStackView.topAnchor),
            dueDateStackView.leadingAnchor.constraint(equalTo: nameNote.leadingAnchor),
            dueDateStackView.bottomAnchor.constraint(equalTo: priorityStackView.bottomAnchor),

            priorityStackView.topAnchor.constraint(equalTo: detailsNote.bottomAnchor, constant: 10),
            priorityStackView.leadingAnchor.constraint(equalTo: dueDateStackView.trailingAnchor, constant: 25),
            priorityStackView.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -16),

        ])
    }
    
    func configure(note: Note) {
        let priority = NotePriority.from(note.priority)
        noteId = note.id
        nameNote.text = note.name
        detailsNote.text = note.details
        priorityIconImage.tintColor = priority.color
        priorityNoteLabel.text = priority.title
        priorityNoteLabel.textColor = priority.color
        updateCheckBox(isCompleted: note.execution)
        if let date = note.dueDate {
            dateLabel.text = date.formatForNoteCell()
            dateLabel.isHidden = false
        } else{
            dateLabel.text = "Не выбрано"
        }

    }
    
    @objc
     func checkboxTapped() {
         guard let id = noteId else { return }
         onToggle?(id)
       }
    
    @objc
    func deleteNoteTapped() {
        guard let id = noteId else { return }
        onDelete?(id)
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
    


