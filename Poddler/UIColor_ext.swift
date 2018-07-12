//
//  UIColor_ext.swift
//  Poddler
//
//  Created by Sven Pohle on 7/11/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

struct ColorTheme {
    static let tabBarTintColor = UIColor(r: 0, g: 110, b: 153)
}

extension UIColor {
    convenience init(r: Double, g: Double, b: Double) {
        self.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(1.0))
    }
}
