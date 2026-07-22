//
//  AddUIImageView.swift
//  m3#8
//
//  Created by Дима Люфт on 16.10.2024.
//

import UIKit

extension UIImage {
    func circularImage() -> UIImage? {
        let diameter = min(size.width, size.height)
        let rect = CGRect(x: (size.width - diameter) / 2, y: (size.height - diameter) / 2, width: diameter, height: diameter)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0.0)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        path.addClip()
        draw(in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: size.width, height: size.height))
        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circularImage
    }
}
