//
//  SwitchTableViewCell.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 24.02.19.
//  Copyright © 2019 Nathan Mattes. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate {
    func didSwitchValue(of cell:SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchElement: UISwitch!
    
    var delegate: SwitchTableViewCellDelegate?

    @IBAction func switchValueChanged(_ sender: AnyObject) {
        self.delegate?.didSwitchValue(of: self)
    }
}
