//
//  EZLCategoryVisbilityTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 29.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLCategoryVisbilityTableViewController: UITableViewController {
    
    var managedObjectContext : NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    var resultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
    var categoryVisibiltySaved: Bool = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SETTINGS.HIDE_CATEGORIES.TITLE", comment: "Hide categories")
        
        let sortDescriptor = NSSortDescriptor(key: "displayOrderValue", ascending: true)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductCategory") //TODO: Put all this CoreData-Type-constants into an Enum
        request.sortDescriptors = [sortDescriptor]
        self.managedObjectContext.undoManager = UndoManager()

        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try self.resultsController?.performFetch()
        } catch let error as NSError {
            NSLog("Coudldn't fetch categories: \(error.localizedDescription)")
        }
        
        self.updateSaveButton()
    }

    // MARK: - Navigation
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil && self.categoryVisibiltySaved == false {
            self.managedObjectContext.rollback()
            self.managedObjectContext.undoManager = nil
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let resultsController = self.resultsController, let fetchedObjects = resultsController.fetchedObjects {
            return fetchedObjects.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "categoryVisibilityCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = cell as? EZLCategoryVisibilityTableViewCell,
            let resultsController = self.resultsController,
            let fetchedObjects = resultsController.fetchedObjects,
            let category = fetchedObjects[indexPath.row] as? ProductCategory
        {
            var switchElementOn = false
         
            if let hidden = category.hidden {
                switchElementOn = hidden.boolValue
            } else {
                switchElementOn = false
            }
            
            cell.switchElement.isOn = switchElementOn
            cell.switchElement.onTintColor = Branding.shared.actionColor
            
            cell.category = category
            cell.label.text = category.name!
            
            cell.delegate = self
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {

        do {
                try managedObjectContext.save()
                NotificationCenter.default.post(name: Notification.Name(rawValue: kOrderOfCategoriesChangedNotificationName), object: nil)
                self.categoryVisibiltySaved = true
                self.navigationController?.popViewController(animated: true)
            } catch let error {
                let errorMessage = "Sorry, the App couldn't save the changed Category order. Please reach out to the developer and tell him about this. (Reason \(error.localizedDescription))"
                
                let errorAlert: UIAlertController = UIAlertController(title: "An unexpected Error occured", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                
                errorAlert.addAction(okAction)
                
                self.present(errorAlert, animated: true, completion: nil)
            }
        
    }
    
    fileprivate func updateSaveButton() {
        self.saveButton.isEnabled = self.managedObjectContext.hasChanges
    }
}

extension EZLCategoryVisbilityTableViewController: SwitchTableViewCellDelegate {
    func didSwitchValue(of cell: SwitchTableViewCell) {
        self.updateSaveButton()
    }
}
