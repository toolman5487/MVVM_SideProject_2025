//
//  LabelFactory.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/11.
//

import Foundation
import UIKit

struct LabelFactory{
    
    static func build(
        text:String?,
        font:UIFont,
        backgroundColor:UIColor = .clear,
        textColor:UIColor = ThemeColor.text,
        textAlignment:NSTextAlignment = .center)->UILabel{
            
            let label = UILabel()
            label.text = text ?? ""
            label.font = font
            label.backgroundColor = backgroundColor
            label.textColor = textColor
            label.textAlignment = textAlignment
            return label
    }
}

