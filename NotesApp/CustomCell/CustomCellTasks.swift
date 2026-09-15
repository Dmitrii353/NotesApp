//
//  CustomCellTasks.swift
//  m3#8
//
//  Created by Дима Люфт on 20.10.2024.
//

import UIKit

class CustomCellTasks: UICollectionViewCell, SetupNewCell {
    static var reuseId: String = "CustomCellTasks"
        
    lazy var addView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 50
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray2.cgColor
        return $0
    }(UIView())
    
    lazy var countNote: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .brownText)
    lazy var nameTask: UILabel = AddLabel(fontText: 18, fontW: .bold, colorText: .black, textAlignmentLabel: .left)
    lazy var datetask: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .brownText)
    lazy var deleteTask: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        $0.tintColor = .darkGray
        return $0
    }(UIButton())
   
    lazy var calendarSystemImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 15).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 15).isActive = true
        $0.image = UIImage(systemName: "calendar")
        $0.tintColor = UIColor.brownText
        return $0
    }(UIImageView())
    
    lazy var iconContainerCategoryImage: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.addSubview(categoryTaskImage)
        return $0
    }(UIView())
    
    lazy var categoryTaskImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var categoryImageAndSettingsButton: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.addArrangesViews(iconContainerCategoryImage, deleteTask)
        return $0
    }(UIStackView())
    
    lazy var progressTaskView: UIProgressView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 6).isActive = true
        $0.progressViewStyle = .default
        $0.layer.cornerRadius = 2
        $0.trackTintColor = .systemGray5
        $0.progress = 0.6
        return $0
    }(UIProgressView())
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupElements()
        setupConstraints()
    }
    
    
    func setupElements() {
        contentView.addSubview(addView)
        addView.addSubViews(nameTask,countNote,calendarSystemImage,datetask,categoryImageAndSettingsButton,progressTaskView)
    }
    
    
    func setupCell(tasks: Tasks) {
        nameTask.text = tasks.name
        countNote.text = tasks.progressText
        progressTaskView.progress = tasks.progress
        if let date = tasks.date {
            datetask.text = date.formatDateForCell()
        } else {
            datetask.text = "нет даты"
        }
        
        categoryTaskImage.image = UIImage(systemName: CategoryTask.icon(for: tasks.name ?? ""))
        iconContainerCategoryImage.backgroundColor = CategoryTask.color(for: tasks.name ?? "")
        categoryTaskImage.tintColor = .white
        progressTaskView.progressTintColor = CategoryTask.color(for: tasks.name ?? "")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.topAnchor),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameTask.topAnchor.constraint(equalTo: categoryImageAndSettingsButton.bottomAnchor, constant: 20),
            nameTask.heightAnchor.constraint(equalToConstant: 20),
            nameTask.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 16),
            nameTask.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -16),
            
            categoryTaskImage.centerYAnchor.constraint(equalTo: iconContainerCategoryImage.centerYAnchor),
            categoryTaskImage.centerXAnchor.constraint(equalTo: iconContainerCategoryImage.centerXAnchor),
            
            categoryImageAndSettingsButton.topAnchor.constraint(equalTo: addView.topAnchor, constant: 20),
            categoryImageAndSettingsButton.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 16),
            categoryImageAndSettingsButton.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -16),

            calendarSystemImage.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 16),
            calendarSystemImage.bottomAnchor.constraint(equalTo: datetask.bottomAnchor),
            
            countNote.topAnchor.constraint(equalTo: nameTask.bottomAnchor, constant: 5),
            countNote.leadingAnchor.constraint(equalTo: nameTask.leadingAnchor),
            countNote.trailingAnchor.constraint(equalTo: nameTask.trailingAnchor),
            
            datetask.leadingAnchor.constraint(equalTo: calendarSystemImage.trailingAnchor, constant: 5),
            datetask.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -5),
            datetask.topAnchor.constraint(equalTo: countNote.bottomAnchor, constant: 5),
            
            progressTaskView.topAnchor.constraint(equalTo: datetask.bottomAnchor, constant: 5),
            progressTaskView.leadingAnchor.constraint(equalTo: nameTask.leadingAnchor,constant: 5),
            progressTaskView.trailingAnchor.constraint(equalTo: nameTask.trailingAnchor, constant: -5)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



