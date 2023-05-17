//
//  Color Extension.swift
//  Meal Planner
//
//  Created by Tyler Radke on 5/10/23.
//

import Foundation
import UIKit
extension UIColor {
    
    static var customLight: UIColor {
        let red: CGFloat = 249
        let green: CGFloat = 247
        let blue: CGFloat = 247
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static var customLightBlue: UIColor {
        let red: CGFloat = 219
        let green: CGFloat = 226
        let blue: CGFloat = 239
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static var customBlue: UIColor {
        let red: CGFloat = 63
        let green: CGFloat = 114
        let blue: CGFloat = 175
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    static var customDarkBlue: UIColor {
        let red: CGFloat = 17
        let green: CGFloat = 45
        let blue: CGFloat = 78
        
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}

extension UIViewController {
        func setColor() {
        view.backgroundColor = .customBlue
        view.tintColor = .customLight
    }
}

extension UITableView {
    func setTableViewColor() {
        self.backgroundColor = .customLightBlue
        self.tintColor = .customLight
    }
}

extension UITableViewCell {
    func setCellColor() {
        self.backgroundColor = .customLightBlue
        self.tintColor = .customLight
    }
}
