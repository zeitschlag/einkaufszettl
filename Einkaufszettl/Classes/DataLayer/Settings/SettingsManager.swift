//
//  SettingsManager.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.11.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import Foundation

@objc
enum SelectionMode: Int {
    case Tap = 1
    case Swipe = 2
    
    static let allValues = [Tap, Swipe]
    
    func readableName() -> String {
        switch (self) {
        case .Tap:
            return NSLocalizedString("SETTINGS.GESTURE.TAP", comment: "")
        case .Swipe:
            return NSLocalizedString("SETTINGS.GESTURE.SWIPE", comment: "")
            
        }
    }
}

class SettingsManager: NSObject {
    
    @objc
    static let shared = SettingsManager()
    
    //MARK: - Selection
    
    private enum SettingsKey {
        static let selectionModeSettings = "kSelectionModeSettingsKey"
        static let sharingTextDisabled = "kSharingTextDisabledSetingsKey"
    }
    
    @objc
    func currentSelectionMode() -> SelectionMode {
        
        let selectionModeInt = UserDefaults.standard.integer(forKey: SettingsKey.selectionModeSettings)
        if let selectionMode = SelectionMode(rawValue: selectionModeInt) {
            return selectionMode
        }
        
        return .Swipe
    }
    
    func setSelectionMode(to selectionMode: SelectionMode) {
        UserDefaults.standard.set(selectionMode.rawValue, forKey: SettingsKey.selectionModeSettings)
        UserDefaults.standard.synchronize()
    }
    
    @objc
    func sharingTextDisabled() -> Bool {
        return UserDefaults.standard.bool(forKey: SettingsKey.sharingTextDisabled)
    }
    
    @objc
    func setDisabledSharingText(to sharingDisabled: Bool) {
        UserDefaults.standard.set(sharingDisabled, forKey: SettingsKey.sharingTextDisabled)
    }
    
}
