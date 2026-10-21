//
//  AddButton.swift
//  NotesApp
//
//  Created by Дима Люфт on 06.10.2026.
//

import UIKit

protocol SetupButtonProtocol: UIButton {
    var radius: CGFloat {get}
    var backColor : UIColor {get}
    var text : String {get}
    var colorText: UIColor {get}
}

class AddButton: UIButton,SetupButtonProtocol {
    var radius: CGFloat
    var backColor : UIColor
    var text : String
    var colorText: UIColor

    
    init(radius: CGFloat = 0, backColor: UIColor = .clear, text: String, colorText: UIColor = .colorButton,) {
        self.radius = radius
        self.backColor = backColor
        self.text = text
        self.colorText = colorText
        super.init(frame: .zero)
        
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(text, for: .normal)
        backgroundColor = backColor
        setTitleColor(colorText, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
