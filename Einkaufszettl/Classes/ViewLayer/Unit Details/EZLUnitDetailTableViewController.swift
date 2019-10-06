//
//  EZLUnitDetailTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 24.05.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLUnitDetailTableViewController: UITableViewController {
    
    @objc var unit: ProductUnit?
    var dataSource: EZLUnitDetailDataSource?
    @objc var managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unit = self.unit else { return }
        
        self.dataSource = EZLUnitDetailDataSource(unit: unit, managedObjectContext: managedObjectContext, buttonCellDelegate: self)
        
        self.tableView.dataSource = self.dataSource
        self.title = unit.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstRow = IndexPath(row: 0, section: 0)

        guard let cell = self.tableView.cellForRow(at: firstRow) as? DetailCellWithTextField else { return }
        
        cell.detailTextField.becomeFirstResponder()
    }
    
    @IBAction func saveUnit(_ sender: Any) {

        let nameRow = IndexPath(row: 0, section: 0)
        guard let nameCell = self.tableView.cellForRow(at: nameRow) as? DetailCellWithTextField else { return }

        let singularRow = IndexPath(row: 1, section: 0)
        guard let singularCell = self.tableView.cellForRow(at: singularRow) as? DetailCellWithTextField else { return }

        let pluralRow = IndexPath(row: 2, section: 0)
        guard let pluralCell = self.tableView.cellForRow(at: pluralRow) as? DetailCellWithTextField else { return }

        let nameOfUnit = nameCell.detailTextField.text
        self.unit?.name = nameOfUnit

        let singularOfUnit = singularCell.detailTextField.text
        self.unit?.singular = singularOfUnit

        let pluralOfUnit = pluralCell.detailTextField.text
        self.unit?.plural = pluralOfUnit

        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            NSLog("Couldn't save unit. Reason: \(error.localizedDescription)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension EZLUnitDetailTableViewController: EZLButtonTableViewCellDelegate {
    func buttonTapped(sender: Any) {
        
        let title = String(format: NSLocalizedString("REMOVE.%@.IRREVOCABLY", comment: ""), self.unit?.name ?? "")
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL.NO", comment:"No"), style: UIAlertActionStyle.cancel, handler: nil)
        let deleteAction = UIAlertAction(title: NSLocalizedString("GENERAL.YES", comment:"Yes"), style: UIAlertActionStyle.destructive) { (_) in
            
            defer {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            guard let unit = self.unit else {
                NSLog("Couldn't remove nonexisting unit")
                return
            }
            
            self.managedObjectContext.delete(unit)
            
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Couldn't save: \(error.localizedDescription)")
            }
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}
