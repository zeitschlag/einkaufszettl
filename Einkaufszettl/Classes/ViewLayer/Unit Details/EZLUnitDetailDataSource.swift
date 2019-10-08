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

    private enum UnitDetailCellType {
        case Name
        case Singular
        case Plural
        case Delete

        static let Sections: [[UnitDetailCellType]] = [[.Name, .Singular, .Plural], [.Delete]]
    }
    
    init(unit: ProductUnit, managedObjectContext: NSManagedObjectContext, buttonCellDelegate: EZLButtonTableViewCellDelegate) {
        
        self.unit = unit
        self.managedObjectContext = managedObjectContext
        self.buttonCellDelegate = buttonCellDelegate

        super.init()
    }
}

extension EZLUnitDetailDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return UnitDetailCellType.Sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UnitDetailCellType.Sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let unitCellIdentifier = "unitDetailCell"
        let deleteUnitCellIdentifier = "deleteUnitCell"

        let type = UnitDetailCellType.Sections[indexPath.section][indexPath.row]

        switch type {
        case .Name:

            let cell = tableView.dequeueReusableCell(withIdentifier: unitCellIdentifier, for: indexPath) as! DetailCellWithTextField

            cell.isNumeric = false
            cell.isDecimalNumeric = false

            cell.detailTitleLabel.text = NSLocalizedString("name", comment: "Name for 'Name of Product'")
            cell.detailTextField.text = unit.name ?? ""
            cell.detailTextField.keyboardType = UIKeyboardType.alphabet
            cell.detailTextField.delegate = cell
            return cell

        case .Singular:

            let cell = tableView.dequeueReusableCell(withIdentifier: unitCellIdentifier, for: indexPath) as! DetailCellWithTextField

            cell.isNumeric = false
            cell.isDecimalNumeric = false

            cell.detailTitleLabel.text = NSLocalizedString("UNITS.SINGULAR", comment: "Singular for 'Name of Product'")
            cell.detailTextField.text = unit.singular ?? unit.name ?? ""
            cell.detailTextField.keyboardType = UIKeyboardType.alphabet
            cell.detailTextField.delegate = cell
            return cell

        case .Plural:

            let cell = tableView.dequeueReusableCell(withIdentifier: unitCellIdentifier, for: indexPath) as! DetailCellWithTextField

            cell.isNumeric = false
            cell.isDecimalNumeric = false

            cell.detailTitleLabel.text = NSLocalizedString("UNITS.PLURAL", comment: "Plural of 'Name of Product'")
            cell.detailTextField.text = unit.plural ?? unit.name ?? ""
            cell.detailTextField.keyboardType = UIKeyboardType.alphabet
            cell.detailTextField.delegate = cell
            return cell

        case .Delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: deleteUnitCellIdentifier, for: indexPath) as! EZLButtonTableViewCell
            cell.delegate = buttonCellDelegate
            cell.button.setTitle(NSLocalizedString("GENERAL.REMOVE", comment: "Remove"), for: UIControlState.normal)

            return cell
        }
    }
}
