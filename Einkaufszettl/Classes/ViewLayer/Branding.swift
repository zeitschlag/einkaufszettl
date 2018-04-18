//
//  Branding.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 14.10.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class Branding: NSObject {
    static let shared = Branding()
    
    //MARK: - Colors
    
    private let redColor = UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0)
    private let gray = UIColor.gray
    private let black = UIColor.black
    
    func actionColor() -> UIColor {
        return self.redColor
    }
    
    func productNotBoughtTextColor() -> UIColor {
        return self.black
    }
    
    func productBoughtTextColor() -> UIColor {
        return self.gray
    }
    
    func strikeThroughColor() -> UIColor {
            return self.redColor
    }
    
    func tintColor() -> UIColor {
        return self.redColor
    }
    
    // MARK: - Fonts
    
    private let defaultBoldFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold)
    private let defaultRegularFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
    private let defaultLightFont = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightLight)
    
    func selectedItemFont() -> UIFont {
        return defaultBoldFont
    }
    
    func unselectedItemFont() -> UIFont {
        return defaultLightFont
    }
}
