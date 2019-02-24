//
//  EZLCategoryVisibilityTableViewCell.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit


class EZLCategoryVisibilityTableViewCell: SwitchTableViewCell {
    
    var category : ProductCategory?

    @IBAction override func switchValueChanged(_ sender: AnyObject) {
        
        if let category = self.category, let sender = sender as? UISwitch {
            category.hidden = NSNumber(value: sender.isOn as Bool)
        }
        
        super .switchValueChanged(sender)
        
    }
}
