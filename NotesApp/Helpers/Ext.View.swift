//
//  File.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
