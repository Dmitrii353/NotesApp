//
//  CustomAllNotesCell.swift
//  NotesApp
//
//  Created by Дима Люфт on 17.11.2026.
//
// это кастомная ячейка таблицы со всеми заметками

import UIKit


 final class CustomAllNotesCell: UITableViewCell {
    
    static let reuseId: String = "CustomAllNotesCell"
    private var noteId: String?
     var onToggle: ((String) -> Void)?
    
   private lazy var addView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 90).isActive = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 18
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        return $0
    }(UIView())
    
   private lazy var checkBox: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.addTarget(self, action: #selector(buttonToggle), for: .touchUpInside)
        return $0
    }(UIButton())
    
   private lazy var nameNoteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
   private lazy var categoryView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return $0
    }(UIView())
    
   private lazy var imageCategoryView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 14).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 14).isActive = true
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
   private lazy var nameCategoryLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, textAlignmentLabel: .center)
   private lazy var dueDateLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel, textAlignmentLabel: .left)
     
     private lazy var priorityLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, textAlignmentLabel: .center)
     private lazy var priorityImageView: UIImageView = {
         $0.translatesAutoresizingMaskIntoConstraints = false
         $0.image = UIImage(systemName: "flag")
         $0.heightAnchor.constraint(equalToConstant: 14).isActive = true
         $0.widthAnchor.constraint(equalToConstant: 14).isActive = true
         $0.contentMode = .scaleAspectFit
         $0.clipsToBounds = true
         return $0
     }(UIImageView())
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .colorBackgroundView
        setupElements()
        setupConstraints()
    }
    
  
    
    func configurate(note: Note) {
        let priority = NotePriority.from(note.priority)
        noteId = note.id
        categoryView.backgroundColor = CategoryTask.color(for: note.tasks?.name ?? "")
        imageCategoryView.tintColor = CategoryTask.colorIcon(for: note.tasks?.name ?? "")
        imageCategoryView.image = UIImage(systemName: CategoryTask.icon(for: note.tasks?.name ?? ""))
        nameCategoryLabel.text = note.tasks?.name
        nameCategoryLabel.textColor = CategoryTask.colorIcon(for: note.tasks?.name ?? "")
        priorityLabel.text = priority.title
        priorityImageView.tintColor = priority.color
        priorityLabel.textColor = priority.color
        if let date = note.dueDate {
            dueDateLabel.text = date.formatForNoteCell()
        } else {
            dueDateLabel.text = "Без срока"
        }
        if note.execution {
            let attributed = NSAttributedString(string: note.name ?? "", attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.secondaryLabel
            ])
            dueDateLabel.text = "Выполнено"
            nameNoteLabel.attributedText = attributed
        } else {
            nameNoteLabel.attributedText = nil
            nameNoteLabel.text = note.name
        }
        updateCheckBox(note.execution)
    }
    
    private func updateCheckBox(_ isCompleted: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = isCompleted ? "checkmark.square.fill" : "square"
        let colorCheck = isCompleted ? UIColor.colorCheckCircleNote : UIColor.colorButton
        checkBox.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
        checkBox.tintColor = colorCheck
    }
    
    @objc
     func buttonToggle() {
        guard let id = noteId else { return }
        onToggle?(id)
    }
    
   private func setupElements() {
        contentView.addSubview(addView)
        addView.addSubViews(checkBox,nameNoteLabel,categoryView,dueDateLabel,priorityImageView,priorityLabel)
        categoryView.addSubViews(imageCategoryView,nameCategoryLabel)
    }
    
   private func setupConstraints() {
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            addView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            addView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -6),
            
            checkBox.topAnchor.constraint(equalTo: addView.topAnchor, constant: 18),
            checkBox.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 16),
            
            nameNoteLabel.topAnchor.constraint(equalTo: checkBox.topAnchor),
            nameNoteLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 11),
            nameNoteLabel.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -40),
            
            categoryView.leadingAnchor.constraint(equalTo: nameNoteLabel.leadingAnchor),
            categoryView.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -16),
            
            imageCategoryView.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: 5),
            imageCategoryView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 10),
            imageCategoryView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: -5),
            
            nameCategoryLabel.topAnchor.constraint(equalTo: categoryView.topAnchor, constant: 4),
            nameCategoryLabel.leadingAnchor.constraint(equalTo: imageCategoryView.trailingAnchor, constant: 4),
            nameCategoryLabel.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: -4),
            nameCategoryLabel.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -10),

            priorityImageView.topAnchor.constraint(equalTo: imageCategoryView.topAnchor),
            priorityImageView.leadingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: 10),
            priorityImageView.bottomAnchor.constraint(equalTo: imageCategoryView.bottomAnchor),
            
            priorityLabel.topAnchor.constraint(equalTo: nameCategoryLabel.topAnchor),
            priorityLabel.bottomAnchor.constraint(equalTo: nameCategoryLabel.bottomAnchor),
            priorityLabel.leadingAnchor.constraint(equalTo: priorityImageView.trailingAnchor, constant: 4),
           
            dueDateLabel.leadingAnchor.constraint(equalTo: priorityLabel.trailingAnchor, constant: 10),
            dueDateLabel.centerYAnchor.constraint(equalTo: priorityLabel.centerYAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
