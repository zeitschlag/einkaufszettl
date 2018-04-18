//
//  EZLUnitDetailDataSource.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 22.05.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLUnitDetailDataSource: NSObject {
    var unit: ProductUnit
    var managedObjectContext: NSManagedObjectContext
    var buttonCellDelegate: EZLButtonTableViewCellDelegate
    
    init(unit: ProductUnit, managedObjectContext: NSManagedObjectContext, buttonCellDelegate: EZLButtonTableViewCellDelegate) {
        
        self.unit = unit
        self.managedObjectContext = managedObjectContext
        self.buttonCellDelegate = buttonCellDelegate
        
    }
    
}

extension EZLUnitDetailDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let unitCellIdentifier = "unitDetailCell"
        let deleteUnitCellIdentifier = "deleteUnitCell"
        
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: unitCellIdentifier, for: indexPath) as? DetailCellWithTextField {
            cell.isNumeric = false
            cell.isDecimalNumeric = false
            
            cell.detailTitleLabel.text = NSLocalizedString("name", comment: "Name for 'Name of Product'")
            cell.detailTextField.text = self.unit.name ?? ""
            cell.detailTextField.keyboardType = UIKeyboardType.alphabet
            cell.detailTextField.delegate = cell
            
            return cell
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: deleteUnitCellIdentifier, for: indexPath) as? EZLButtonTableViewCell {
            cell.delegate = self.buttonCellDelegate
            cell.button.setTitle(NSLocalizedString("GENERAL.REMOVE", comment: "Remove"), for: UIControlState.normal)
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: unitCellIdentifier, for: indexPath)
    }
}
