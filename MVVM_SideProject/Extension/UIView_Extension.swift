//
//  UIView_Extension.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/11.
//

import Foundation
import UIKit

extension UIView{
    
    func addShadow(offset:CGSize, color:UIColor, radius:CGFloat, opacity:Float){
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    
    func addCornerRadius(radius:CGFloat){
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
