//
//  CustomCellNoteMainView.swift
//  NotesApp
//
//  Created by Дима Люфт on 16.10.2026.
//

import UIKit

class CustomCellNoteMainView: UITableViewCell, SetupNewCell {
    static let reuseId: String = "CustomCellNoteMainView"
    private var noteId: String?
    var onToggle: ((String) -> Void)?
    lazy var tableNoteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray2.cgColor
        $0.heightAnchor.constraint(equalToConstant: 64).isActive = true
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowRadius = 4
        return $0
    }(UIView())
    
    lazy var iconContainerCategoryImage: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addSubview(categoryNotesImage)
        return $0
    }(UIView())
    lazy var categoryNotesImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    lazy var nameNotesLabel: UILabel = AddLabel(fontText: 16, fontW: .heavy, colorText: .colorLabel, textAlignmentLabel: .left)
    lazy var categoryNotesLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel)
    lazy var dateNotesLabel: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .colorDescriptionLabel)
    lazy var descriptionNoteStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .leading
        $0.heightAnchor.constraint(equalToConstant: 16).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 160).isActive = true
        $0.addArrangesViews(categoryNotesLabel,dateNotesLabel)
        return $0
    }(UIStackView())
    lazy var noteIsCompleted: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .colorCheckCircleNote
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .colorBackgroundView
        setupElements()
        setupConstraints()
    }
    
    func setupElementsCell(note: Note) {
        
        let categoryName = note.tasks?.name ?? ""
        iconContainerCategoryImage.backgroundColor = CategoryTask.color(for: categoryName)
        categoryNotesImage.image = UIImage(systemName: CategoryTask.icon(for: categoryName))
        categoryNotesImage.tintColor = CategoryTask.colorIcon(for: categoryName)
        nameNotesLabel.text = note.name
        categoryNotesLabel.text = categoryName
        noteId = note.id
        updateCheckBox(is: note.execution)
        if let date = note.tasks?.date {
            dateNotesLabel.text = date.formatDateForCell()
        } else {
            dateNotesLabel.text = "· без даты"
        }
    }
    
    func setupElements() {
        contentView.addSubview(tableNoteView)
        tableNoteView.addSubViews(iconContainerCategoryImage,
                                  nameNotesLabel,
                                  descriptionNoteStackView,
                                  noteIsCompleted)
    }
    
    
    @objc
    func checkBoxTapped() {
        guard let id = noteId else { return }
        onToggle?(id)
    }
    
    private func updateCheckBox(is completed: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = completed ? "checkmark.circle.fill" : "circle"
        noteIsCompleted.setImage(UIImage(systemName: image, withConfiguration: config), for: .normal)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableNoteView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            tableNoteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableNoteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconContainerCategoryImage.topAnchor.constraint(equalTo: tableNoteView.topAnchor, constant: 12),
            iconContainerCategoryImage.leadingAnchor.constraint(equalTo: tableNoteView.leadingAnchor, constant: 12),
            iconContainerCategoryImage.bottomAnchor.constraint(equalTo: tableNoteView.bottomAnchor, constant: -12),
            
            categoryNotesImage.centerXAnchor.constraint(equalTo: iconContainerCategoryImage.centerXAnchor),
            categoryNotesImage.centerYAnchor.constraint(equalTo: iconContainerCategoryImage.centerYAnchor),
            
            nameNotesLabel.leadingAnchor.constraint(equalTo: iconContainerCategoryImage.trailingAnchor, constant: 12),
            nameNotesLabel.topAnchor.constraint(equalTo: iconContainerCategoryImage.topAnchor),
            nameNotesLabel.heightAnchor.constraint(equalToConstant: 20),
            nameNotesLabel.widthAnchor.constraint(equalToConstant: 250),
            
            descriptionNoteStackView.topAnchor.constraint(equalTo: nameNotesLabel.bottomAnchor),
            descriptionNoteStackView.leadingAnchor.constraint(equalTo: nameNotesLabel.leadingAnchor),
            
            noteIsCompleted.trailingAnchor.constraint(equalTo: tableNoteView.trailingAnchor, constant: -12),
            noteIsCompleted.topAnchor.constraint(equalTo: tableNoteView.topAnchor, constant: 20),
            noteIsCompleted.bottomAnchor.constraint(equalTo: tableNoteView.bottomAnchor, constant: -20),
            
            tableNoteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
