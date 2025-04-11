//
//  ThemeFont.swift
//  MVVM_SideProject
//
//  Created by Willy Hsu on 2025/4/11.
//

import Foundation
import UIKit

struct ThemeFont {
    
    static func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func demiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProRounded-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}
