//
//  AddUIStackView.swift
//  NotesApp
//
//  Created by Дима Люфт on 06.10.2026.
//

import UIKit

protocol SetupStackViewProtocol: UIStackView {
    var height: CGFloat {get}
    var distributionStack: UIStackView.Distribution {get}
}

class AddUIStackView: UIStackView, SetupStackViewProtocol {
    var distributionStack: UIStackView.Distribution
    var height: CGFloat
    
    init(height: CGFloat, distributionStack: Distribution = .equalSpacing) {
        self.height = height
        self.distributionStack = distributionStack
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        distribution = distributionStack
        axis = .horizontal
        alignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
