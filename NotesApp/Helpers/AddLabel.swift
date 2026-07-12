//
//  AddLabel.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

protocol SetupLabel:UILabel {
    var fontText: CGFloat {get}
    var fontW: UIFont.Weight {get}
    var colorText: UIColor {get}
}

class AddLabel: UILabel, SetupLabel {
    var fontText: CGFloat
    var fontW: UIFont.Weight
    var colorText: UIColor
    var textAlignmentLabel: NSTextAlignment
    
    init(fontText: CGFloat,fontW: UIFont.Weight,colorText: UIColor, textAlignmentLabel: NSTextAlignment = .justified){
        self.fontText = fontText
        self.fontW = fontW
        self.colorText = colorText
        self.textAlignmentLabel = textAlignmentLabel

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = colorText
        font = .systemFont(ofSize: fontText, weight: fontW)
        textAlignment = textAlignmentLabel
//        numberOfLines = 0
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
