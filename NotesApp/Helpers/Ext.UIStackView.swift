//
//  Ext.UIStackView.swift
//  m3#8
//
//  Created by Дима Люфт on 20.10.2024.
//

import UIKit

extension UIStackView {
    func addArrangesViews(_ view: UIView...) {
        view.forEach{
            self.addArrangedSubview($0)
        }
    }
}
