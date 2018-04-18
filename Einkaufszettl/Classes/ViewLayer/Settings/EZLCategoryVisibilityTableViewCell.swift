//
//  EZLCategoryVisibilityTableViewCell.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit

protocol EZLCategoryVisibilityTableViewCellDelegate {
    func didSwitchValue(of cell:EZLCategoryVisibilityTableViewCell)
}

class EZLCategoryVisibilityTableViewCell: UITableViewCell {
    
    var category : ProductCategory?
    
    var delegate: EZLCategoryVisibilityTableViewCellDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchElement: UISwitch!

    @IBAction func switchValueChanged(_ sender: AnyObject) {
        
        if let category = self.category, let sender = sender as? UISwitch {
            category.hidden = NSNumber(value: sender.isOn as Bool)
        }
        
        self.delegate?.didSwitchValue(of: self)
        
    }
}
