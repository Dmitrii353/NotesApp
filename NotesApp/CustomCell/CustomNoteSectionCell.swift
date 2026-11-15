//
//  CustomNoteSectionCollectionCell.swift
//  NotesApp
//
//  Created by Дима Люфт on 15.11.2026.
//

import UIKit

final class CustomNoteSectionCell: UICollectionViewCell, SetupNewCell {
    static let reuseId: String = "CustomNoteSectionCell"
    
    
    lazy var titleLabel: UILabel = AddLabel(fontText: 14, fontW: .medium,textAlignmentLabel: .center)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupElements()
        setupConstraints()
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? UIColor.white : UIColor.black
        contentView.backgroundColor = isSelected ? .colorButton : .systemGray6
    }
    
     func setupElements() {
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
