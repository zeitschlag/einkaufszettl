//
//  SettingsManager.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.11.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import Foundation

@objc enum SelectionMode: Int {
    case Tap = 1
    case Swipe = 2
    
    static let allValues = [Tap, Swipe]
    
    func readableName() -> String {
        switch (self) {
        case .Tap:
            return "Tap"
        case .Swipe:
            return "Wischgeste"
            
        }
    }
}

class SettingsManager: NSObject {
    
    static let shared = SettingsManager()
    
    //MARK: - Selection
    
    private let selectionModeSettingsKey = "kSelectionModeSettingsKey"
    
    func currentSelectionMode() -> SelectionMode {
        
        let selectionModeInt = UserDefaults.standard.integer(forKey: self.selectionModeSettingsKey)
        if let selectionMode = SelectionMode(rawValue: selectionModeInt) {
            return selectionMode
        }
        
        return .Swipe
    }
    
    func setSelectionMode(to selectionMode: SelectionMode) {
        UserDefaults.standard.set(selectionMode.rawValue, forKey: self.selectionModeSettingsKey)
        UserDefaults.standard.synchronize()
    }
    
    
    
}
