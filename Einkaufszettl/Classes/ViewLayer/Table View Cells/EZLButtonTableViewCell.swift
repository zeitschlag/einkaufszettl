//
//  EZLButtonTableViewCell.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 24.05.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

@objc protocol EZLButtonTableViewCellDelegate {
    func buttonTapped(sender: Any)
}

class EZLButtonTableViewCell: UITableViewCell {
    
    var delegate: EZLButtonTableViewCellDelegate?
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.delegate?.buttonTapped(sender: sender)
    }
    
}
