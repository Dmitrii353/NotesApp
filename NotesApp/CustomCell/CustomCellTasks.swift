//
//  CustomCellTasks.swift
//  m3#8
//
//  Created by Дима Люфт on 20.10.2024.
//

import UIKit

class CustomCellTasks: UICollectionViewCell, SetupNewCell {
    static var reuseId: String = "CustomCellTasks"
    
    private var colorCell: [UIColor] = [.lightBlue,.lighthacky,.lightPink,.lightPurple,.lightYellow, .lightPeach,.lightOrange, .lightGreen, .lightBlue2]
    lazy var addView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 14
        $0.backgroundColor = colorCell.randomElement()
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        return $0
    }(UIView())
    lazy var countNote: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .brownText)
    lazy var nameTask: UILabel = AddLabel(fontText: 18, fontW: .bold, colorText: .black, textAlignmentLabel: .center)
    lazy var datetask: UILabel = AddLabel(fontText: 12, fontW: .medium, colorText: .brownText)
    lazy var deleteTask: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        $0.tintColor = .darkGray
        $0.heightAnchor.constraint(equalToConstant: 25).isActive = true
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupElements()
        setupConstraints()
    }
    
    
    func setupElements() {
        contentView.addSubview(addView)
        addView.addSubViews(nameTask,countNote,calendarSystemImage,datetask,deleteTask)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            addView.widthAnchor.constraint(equalToConstant: 171),
            addView.heightAnchor.constraint(equalToConstant: 100),
            
            nameTask.centerYAnchor.constraint(equalTo: addView.centerYAnchor),
            nameTask.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            nameTask.heightAnchor.constraint(equalToConstant: 20),
            nameTask.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            nameTask.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
            
            deleteTask.topAnchor.constraint(equalTo: addView.topAnchor,constant: 10),
            deleteTask.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -10),
            deleteTask.widthAnchor.constraint(equalToConstant: 25),

            calendarSystemImage.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 10),
            calendarSystemImage.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -5),
            
            countNote.bottomAnchor.constraint(equalTo: datetask.topAnchor, constant: -5),
            countNote.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            

            datetask.leadingAnchor.constraint(equalTo: calendarSystemImage.trailingAnchor, constant: 5),
            datetask.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -5),
            datetask.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -5),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



