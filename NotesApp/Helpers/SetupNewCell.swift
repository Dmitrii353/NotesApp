//
//  File.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import Foundation


protocol SetupNewCell: AnyObject {
    static var reuseId: String { get }
    
    func setupElements()
    func setupConstraints()
}
