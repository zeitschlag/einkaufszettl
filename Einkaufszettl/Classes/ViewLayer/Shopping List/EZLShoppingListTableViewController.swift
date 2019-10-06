//
//  EZLShoppingListTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 27.05.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLShoppingListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    var resultsController: NSFetchedResultsController<Product>?
    
    let branding = Branding.shared

    @IBOutlet weak var trashBinButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    @IBOutlet weak var sharingButton: UIBarButtonItem!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSuccessMessage(_:)), name: Notification.Name(kShoppingFinishedNotificationName), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.numberOfBoughtThingsChanged(_:)), name: Notification.Name(kNumberOfBoughtThingsChangedNotificationName), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.categoryOrderChanged(_:)), name: Notification.Name(kOrderOfCategoriesChangedNotificationName), object: nil)
        
        let categoryOrderedProductsRequest: NSFetchRequest<Product> = Product.fetchRequest() as! NSFetchRequest<Product>
        
        let filterForInList = NSPredicate(format: "onList == 1")
        categoryOrderedProductsRequest.predicate = filterForInList
        
        let sortByBought = NSSortDescriptor(key: "bought", ascending: true)
        let sortByCategory = NSSortDescriptor(key: "category.displayOrderValue", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        
        categoryOrderedProductsRequest.sortDescriptors = [sortByBought, sortByCategory, sortByName]
        
        let resultsController = NSFetchedResultsController(fetchRequest: categoryOrderedProductsRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch let error as NSError {
            //TODO: Error Handling!
            NSLog("Couldn't fetch Produts: \(error.localizedDescription)")
        }
        
        self.resultsController = resultsController
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let alertShown = UserDefaults.standard.bool(forKey: kMaxDisplayOrderValueBugFixedAlertShownKey)
        
        if alertShown != true {
            let title = NSLocalizedString("", comment: "")
            let message = NSLocalizedString("DISPLAY_ORDER_BUG_MESSAGE", comment: "")
            
            let showMigrationWarningAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("GENERAL.OK", comment: ""), style: .default, handler: nil)
            showMigrationWarningAlert.addAction(okAction)
            
            self.present(showMigrationWarningAlert, animated: true, completion: {
                UserDefaults.standard.set(true, forKey: kMaxDisplayOrderValueBugFixedAlertShownKey)
            })
        }
        
        setupSettingsButton()
    }
    
    private func setupSettingsButton() {
        settingsButton.accessibilityLabel = NSLocalizedString("SHOPPING_LIST.SETTINGS.TITLE.ACCESSIBILITY.LABEL", comment: "")
        settingsButton.accessibilityHint = NSLocalizedString("SHOPPING_LIST.SETTINGS.TITLE.ACCESSIBILITY.HINT", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateTrashBinButtonVisibility()
        self.updateSharingButtonVisibility()
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showThingDetails" {
            guard let cell = sender as? UITableViewCell else { return }
            guard let resultsController = self.resultsController else { return }
            guard let indexPath = self.tableView.indexPath(for: cell) else { return }
            guard let destination = segue.destination as? EZLThingDetailTableViewController else { return }
            
            let selectedProduct = resultsController.object(at: indexPath)
            destination.managedObjectContext = self.managedObjectContext
            destination.product = selectedProduct
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard SettingsManager.shared.currentSelectionMode() == .Tap else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let resultsController = self.resultsController else {
            return
        }
       
        let selectedProduct = resultsController.object(at: indexPath)
        self.toggleBought(of: selectedProduct)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if SettingsManager.shared.currentSelectionMode() == .Tap {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if SettingsManager.shared.currentSelectionMode() == .Swipe {
            return true
        } else {
            return false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard SettingsManager.shared.currentSelectionMode() == .Swipe else {
            return nil
        }
        
        guard let resultsController = self.resultsController else {
            return nil
        }
        
        let selectedProduct = resultsController.object(at: indexPath)
        
        var toggleBoughtActionTitle = ""
        
        if (selectedProduct.bought?.boolValue ?? false) == true {
            toggleBoughtActionTitle = NSLocalizedString("SHOPPING_LIST.BUY_AGAIN", comment: "")
        } else {
            toggleBoughtActionTitle = NSLocalizedString("SHOPPING_LIST.BOUGHT", comment: "")
        }
        
        let toggleBoughtAction = UIContextualAction(style: .normal, title: toggleBoughtActionTitle) { (action, view, completionHandler) in
            self.toggleBought(of: selectedProduct)
            completionHandler(true)
        }
        
        toggleBoughtAction.backgroundColor = Branding.shared.actionColor()
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [toggleBoughtAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeActionConfiguration
        
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard SettingsManager.shared.currentSelectionMode() == .Swipe else {
            return nil
        }
        
        guard let resultsController = self.resultsController else {
            return nil
        }

        let selectedProduct = resultsController.object(at: indexPath)
        
        let removeFromListActionTitle = NSLocalizedString("SHOPPING_LIST.REMOVE_FROM_LIST", comment: "")
        
        let removeFromListAction = UIContextualAction(style: .normal, title: removeFromListActionTitle) { (action, view, completionHandler) in
            self.remove(ProductsFromList: [selectedProduct])
            completionHandler(true)

        }
        
        removeFromListAction.backgroundColor = Branding.shared.actionColor()
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [removeFromListAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeActionConfiguration
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    //MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "thingCell"
        
        guard let resultsController = self.resultsController else {
            NSLog("No resultsController!")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let selectedProduct = resultsController.object(at: indexPath)
        
        self.configure(cell: cell, with: selectedProduct)
        
        return cell
    }
    
    func configure(cell: UITableViewCell, with product: Product) {
        
        guard let productName = product.name else {
            NSLog("Product \(product) has no name")
            return
        }
        
        let productBought = product.bought?.boolValue
        var textLabelText = NSAttributedString(string: productName)
        
        if productBought == true {
            textLabelText = NSAttributedString(string: productName, attributes: [
                NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue,
                NSAttributedStringKey.strikethroughColor: branding.strikeThroughColor(),
                NSAttributedStringKey.foregroundColor: branding.productBoughtTextColor(),
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.light)
                ])
        } else {
            textLabelText = NSAttributedString(string: productName, attributes: [
                NSAttributedStringKey.foregroundColor: branding.productNotBoughtTextColor(),
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)
                ])
        }
        
        cell.textLabel?.attributedText = textLabelText
        cell.detailTextLabel?.text = product.detailText
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let resultsController = self.resultsController else {
            NSLog("No Results Controller!")
            return 0
        }
        
        guard let sections = resultsController.sections else {
            NSLog("No Sections!")
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    //MARK: - Actions
    
    @IBAction func trashBinButtonTapped(_ sender: Any) {
        
        guard let fetchedObjects = self.resultsController?.fetchedObjects else { return }
        
        let boughtThings = fetchedObjects.filter { (product) -> Bool in
            guard let bought = product.bought else { return false }
            
            return bought.boolValue == true
        }
        
        let unboughtThings = fetchedObjects.filter { (product) -> Bool in
            guard let bought = product.bought else { return false }
            
            return bought.boolValue == false
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if boughtThings.count > 0 && unboughtThings.count != 0 {
            let actionTitle = NSLocalizedString("SHOPPING_LIST.REMOVE.MARKED_ONLY", comment: "Nur markierte entfernen");
            let removeBoughtProducts = UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
                self.remove(ProductsFromList: boughtThings)
                
                self.updateSharingButtonVisibility()
                self.updateTrashBinButtonVisibility()
            })
            
            alertController.addAction(removeBoughtProducts)
        }
        
        if fetchedObjects.count > 0 {
            let actionTitle = NSLocalizedString("SHOPPING_LIST.REMOVE.ALL", comment: "Alle entfernen")
            let removeAllProducts = UIAlertAction(title: actionTitle, style: .destructive, handler: { (_) in
                self.remove(ProductsFromList: fetchedObjects)
                
                self.updateSharingButtonVisibility()
                self.updateTrashBinButtonVisibility()
            })
            
            alertController.addAction(removeAllProducts)
        }
        
        let cancelTitle = NSLocalizedString("GENERAL.CANCEL", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        guard let fetchedObjects = self.resultsController?.fetchedObjects else { return }
        
        var sharingString = ""
        let unboughtObjects = fetchedObjects.filter { (product) -> Bool in
            return product.bought?.boolValue == false
        }
        
        let unboughtProductTexts = unboughtObjects.compactMap { (product) -> String? in

            guard let name = product.name else { return nil }

            var completeProductString: String = "- "

            if let unitText = product.amountAndUnit {
                completeProductString.append(unitText + " ")
            }

            completeProductString.append(name)

            return completeProductString
        }
        
        sharingString.append(unboughtProductTexts.joined(separator: "\n"))
        
        let activityViewController = UIActivityViewController(activityItems: [sharingString], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    private func toggleBought(of product: Product) {
        
        guard let resultsController = self.resultsController else { return }
        
        let bought = product.bought?.boolValue ?? false
        
        product.bought = NSNumber(booleanLiteral: bought == false)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            NSLog("Couldn't save managedObjectContext. \(error.localizedDescription)")
        }
        
        if let products = resultsController.fetchedObjects {
            let amountOfUnboughtThings = products.filter({ (product) -> Bool in
                return (product.bought?.boolValue ?? false) == false
            }).count
            
            if amountOfUnboughtThings == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(kShoppingFinishedNotificationName), object: nil)
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(kNumberOfBoughtThingsChangedNotificationName), object: nil)
    }
    
    func remove(ProductsFromList products: [Product]) {
        for product in products {
            product.bought = NSNumber(value: false as Bool)
            product.onList = NSNumber(value: false as Bool)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            NSLog("An error occured: \((error as NSError).localizedDescription)")
        }
    }

    
    //MARK: - Notifications
    
    @objc func showSuccessMessage(_ notification: Notification) {
        
        let title = NSLocalizedString("shopping.finished.title", comment: "")
        let message = NSLocalizedString("shopping.finished.message", comment: "Message for success-popup, if shopping is done")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("GENERAL.OK", comment: "OK"), style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func categoryOrderChanged(_ notification: Notification) {
        
        guard let resultsController = self.resultsController else {
            NSLog("No ResultsController!")
            return
        }
        
        do {
            try resultsController.performFetch()
            self.tableView.reloadData()
        } catch let error as NSError {
            NSLog("Couldn't perform fetch: \(error.localizedDescription)")
        }
    }
    
    @objc func numberOfBoughtThingsChanged(_ notification: Notification) {
        self.updateTrashBinButtonVisibility()
        self.updateSharingButtonVisibility()
    }
    
    func updateTrashBinButtonVisibility() {
        guard let fetchedObjects = self.resultsController?.fetchedObjects
            else { return }
        
        let amountOfThings = fetchedObjects.count
        
        if amountOfThings > 0 {
            self.trashBinButton.isEnabled = true
        } else {
            self.trashBinButton.isEnabled = false
        }
        
    }
    
    func updateSharingButtonVisibility() {
        guard let resultsController = self.resultsController,
            let fetchedObjects = resultsController.fetchedObjects
            else { return }
        
        let amountOfUnboughtThings = fetchedObjects.filter { (product) -> Bool in
            return product.bought == NSNumber(booleanLiteral: false)
            }.count
        
        if amountOfUnboughtThings > 0 {
            self.sharingButton.isEnabled = true
        } else {
            self.sharingButton.isEnabled = false
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        guard let resultsController = self.resultsController else { return }
        
        if resultsController == controller {
            self.tableView.beginUpdates()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        guard let resultsController = self.resultsController else { return }
        
        if resultsController == controller {
            self.tableView.endUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let resultsController = self.resultsController else { return }
        
        let fadeAnimation = UITableViewRowAnimation.fade
        
        if controller == resultsController {
            switch type {
            case .delete:
                if let indexPath = indexPath {
                    self.tableView.deleteRows(at: [indexPath], with: fadeAnimation)
                }
            case .update:
                if let indexPath = indexPath {
                    self.tableView.reloadRows(at: [indexPath], with: fadeAnimation)
                }
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.tableView.insertRows(at: [newIndexPath], with: fadeAnimation)
                }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    self.tableView.deleteRows(at: [indexPath], with: fadeAnimation)
                    self.tableView.insertRows(at: [newIndexPath], with: fadeAnimation)
                }
            }
        }
        
        self.updateTrashBinButtonVisibility()
        self.updateSharingButtonVisibility()
    }
}
