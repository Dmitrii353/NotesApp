//
//  CustomNoteSectionCollectionCell.swift
//  NotesApp
//
//  Created by Дима Люфт on 15.11.2026.
//

import UIKit

final class CustomNoteSectionCell: UICollectionViewCell, SetupNewCell {
    static let reuseId: String = "CustomNoteSectionCell"
    
    lazy var addView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 0.2
        $0.layer.shadowColor = UIColor.colorOther.cgColor
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupElements()
        setupConstraints()
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? UIColor.white : UIColor.black
        addView.backgroundColor = isSelected ? .colorButton : .white
    }
    
     func setupElements() {
         contentView.addSubview(addView)
         addView.addSubview(titleLabel)

    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: contentView.topAnchor),
            addView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: addView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: addView.leadingAnchor,constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: addView.trailingAnchor,constant: -14),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
