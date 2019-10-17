//
//  Branding.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 14.10.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

/**
Ich will das Branding auf PodcastAnalytics umbauen. Ich brauche:
- eine TextColor
- eine DetailTextColor
- eine BackgroundColor
- eine ActionColor
 */

extension UIColor {

    enum CustomColors: String {

        case defaultText = "defaultTextColor"
        case actionText = "actionTextColor"
        case defaultBackground = "defaultBackgroundColor"
        case highlightBackground = "highlightBackgroundColor"
        case highlightText = "highlightTextColor"

        var color: UIColor {
            return UIColor(named: self.rawValue) ?? UIColor.systemRed
        }
    }
}

class Branding: NSObject {

    @objc
    static let shared = Branding()

    let defaultTextColor = UIColor.CustomColors.defaultText.color
    let defaultBackgroundColor = UIColor.CustomColors.defaultBackground.color
    let highlightBackgroundColor = UIColor.CustomColors.highlightBackground.color
    let highlightTextColor = UIColor.CustomColors.highlightText.color
    let actionColor = UIColor.CustomColors.actionText.color

    let defaultTextFont = UIFont.preferredFont(forTextStyle: .body)
    let defaultDetailTextFont = UIFont.preferredFont(forTextStyle: .footnote)

    @objc
    func setupBranding() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = actionColor
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: defaultTextColor
        ]
    }
}

class OldBranding: NSObject {
    @objc
    static let shared = OldBranding()
    
    //MARK: - Colors
    
    private let redColor = UIColor(red: 204/255, green: 0/255, blue: 0/255, alpha: 1.0)
    private let gray = UIColor.gray
    
    @objc
    func actionColor() -> UIColor {
        return Branding.shared.actionColor
    }
    
    func productNotBoughtTextColor() -> UIColor {
        return Branding.shared.defaultTextColor
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
    
    private let defaultBoldFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
    private let defaultRegularFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
    private let defaultLightFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.light)
    
    @objc
    func selectedItemFont() -> UIFont {
        return defaultBoldFont
    }
    
    @objc
    func unselectedItemFont() -> UIFont {
        return defaultLightFont
    }
}
