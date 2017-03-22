//
//  UIColorExtensions.swift
//  ANN
//
//  Created by user125215 on 3/22/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

extension UIColor {
    
    public class var menuButton: UIColor {
        return UIColor.colorFrom(red: 44.0, green: 62.0, blue: 80.0)
    }
    
    public class var menuBackground: UIColor {
        return UIColor.colorFrom(red: 236.0, green: 240.0, blue: 241.0)
    }
    
    class func colorFrom(red: CGFloat, green:CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
