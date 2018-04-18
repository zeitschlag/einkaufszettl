//
//  EZLCategoryDetailDataSouce.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 25.05.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import Foundation
import CoreData

class EZLCategoryDetailDataSource: NSObject {
    
    var category: ProductCategory
    var managedObjectContext: NSManagedObjectContext
    var buttonCellDelegate: EZLButtonTableViewCellDelegate
    
    init(category: ProductCategory, managedObjectContext: NSManagedObjectContext, buttonCellDelegate: EZLButtonTableViewCellDelegate) {
        self.category = category
        self.managedObjectContext = managedObjectContext
        self.buttonCellDelegate = buttonCellDelegate
    }
    
}

extension EZLCategoryDetailDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryNameCellIdentifier = "categoryNameCellIdentifier"
        let deleteCategoryCellIdentifier = "deleteCategoryCellIdentifier"

        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: categoryNameCellIdentifier, for: indexPath) as? DetailCellWithTextField {
                
                cell.isNumeric = false
                cell.isDecimalNumeric = false
                
                cell.detailTitleLabel.text = NSLocalizedString("name", comment: "Name")
                
                cell.detailTextField.text = self.category.name
                cell.detailTextField.keyboardType = UIKeyboardType.alphabet
                cell.detailTextField.delegate = cell
                
                return cell
            }
        }
        
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: deleteCategoryCellIdentifier, for: indexPath) as? EZLButtonTableViewCell {
                
                cell.delegate = self.buttonCellDelegate
                cell.button.setTitle(NSLocalizedString("GENERAL.REMOVE", comment: "Remove"), for: UIControlState.normal)
                
                return cell
            }
        }
        
         
        return UITableViewCell()
    }
}
