//
//  EZLCategoryOrderTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 12.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLCategoryOrderTableViewController: UITableViewController {

    let cellIdentifier = "categoryOrderCell"
    var managedObjectContext : NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    var resultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var categoryOrderSaved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let undoManager = UndoManager()
        self.managedObjectContext.undoManager = undoManager

        let sortDescriptor = NSSortDescriptor(key: "displayOrderValue", ascending: true)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductCategory") //TODO: Put all this CoreData-Type-constants into an Enum
        request.sortDescriptors = [sortDescriptor]
        
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.resultsController?.delegate = self
        
        do {
            try self.resultsController?.performFetch()
        } catch {
            //TODO: Error Handling
        }
        
        
        self.title = NSLocalizedString("SETTINGS.CATEGORY_DISPLAY_ORDER.TITLE", comment: "Title of Category Display Order")
        
        self.isEditing = true
        
        self.updateSaveButton()
    }
    
    // MARK: - Navigation
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil && self.categoryOrderSaved == false {
            self.managedObjectContext.rollback()
            self.managedObjectContext.undoManager = nil
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = self.resultsController?.fetchedObjects?.count {
            return numberOfRows
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)!
        
        if let resultsController = self.resultsController, let category = resultsController.fetchedObjects![indexPath.row] as? ProductCategory {
            cell.textLabel?.text = category.name
        }

        cell.showsReorderControl = true
        return cell
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard let resultsController = self.resultsController else {
            return
        }
        
        let fromIndex = sourceIndexPath.row
        let toIndex = destinationIndexPath.row
        
        if (fromIndex == toIndex) {
            return;
        }
        
        guard let fetchedObjects = resultsController.fetchedObjects, let affectedObject = fetchedObjects[fromIndex] as? ProductCategory else {
            return
        }
        
        affectedObject.displayOrderValue = toIndex as NSNumber //NSNumber(integer:toIndex)
        
        var end : Int
        var start : Int
        var delta : Int
        
        if (fromIndex < toIndex) {
            // move was down, need to shift up
            delta = -1
            start = fromIndex + 1
            end = toIndex
        } else { // fromIndex > toIndex
            // move was up, need to shift down
            delta = 1
            start = toIndex
            end = fromIndex - 1
        }
        
        for i in start...end {
            if let otherObject = fetchedObjects[i] as? ProductCategory {
                let newDisplayOrderValue = otherObject.displayOrderValue!.intValue + delta
                otherObject.displayOrderValue = NSNumber(value: newDisplayOrderValue as Int)
            }
        }
        
        self.updateSaveButton()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {

        do {
                try self.managedObjectContext.save()
                self.categoryOrderSaved = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: kOrderOfCategoriesChangedNotificationName), object: nil)
                self.navigationController?.popViewController(animated: true)
            } catch let error {
                let errorMessage = "Sorry, the App couldn't save the changed Category order. Please reach out to the developer and tell him about this. (Reason \(error.localizedDescription))"
                
                let errorAlert: UIAlertController = UIAlertController(title: "Unexpected Error occured", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                
                errorAlert.addAction(okAction)
                
                self.present(errorAlert, animated: true, completion: nil)
            
        }
    }
    
    private func updateSaveButton() {        
        self.saveButton.isEnabled = managedObjectContext.hasChanges
    }
}

extension EZLCategoryOrderTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
