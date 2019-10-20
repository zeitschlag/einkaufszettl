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

    @objc static let shared = Branding()

    // MARK: - Colors

    @objc let defaultTextColor = UIColor.CustomColors.defaultText.color
    let defaultBackgroundColor = UIColor.CustomColors.defaultBackground.color
    @objc let actionColor = UIColor.CustomColors.actionText.color

    let strikeThroughColor = UIColor.CustomColors.actionText.color
    let productBoughtTextColor = UIColor.gray

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

    // MARK: - Fonts

    private let defaultBoldFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
    private let defaultRegularFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
    private let defaultLightFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.light)

    @objc var selectedItemFont: UIFont {
        return defaultBoldFont
    }

    @objc var unselectedItemFont: UIFont {
        return defaultLightFont
    }

}
