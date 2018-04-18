//
//  EZLAddThingsTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 19.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLAddThingsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    var managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    var resultsController: NSFetchedResultsController<Product>?
    var searchController: EZLSearchController?
    var addedProducts = [Product]()
    
    @IBOutlet weak var createNewProductButton: UIBarButtonItem!
    
    //MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EZLAddThingsTableViewController.categoryOrderChanged(_:)), name: Notification.Name(kOrderOfCategoriesChangedNotificationName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("PRODUCT_LIST.TITLE", comment: "")
        
        //TODO: Move this whole fetching-stuff to the data-layer. DESIGN, Nathan, DESIGN.
        let request: NSFetchRequest<Product> = Product.fetchRequest() as! NSFetchRequest<Product>
        
        let sortByAddedToList = NSSortDescriptor(key: "addedToList", ascending: false)
        let sortByCategory = NSSortDescriptor(key: "category.displayOrderValue", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortByAddedToList, sortByCategory, sortByName]
        
        let visibleCategoriesOnly = NSPredicate(format: "category.hidden == 0 || category == nil")
        
        request.predicate = visibleCategoriesOnly
        
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.resultsController?.delegate = self
        
        do {
            try self.resultsController?.performFetch()
        } catch let error as NSError {
            NSLog("Error while fetching the products: \(error.localizedDescription)")
            return
        }
        
        self.searchController = EZLSearchController(searchResultsController: nil)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.definesPresentationContext = true
        self.searchController?.hidesNavigationBarDuringPresentation = false
        
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.searchBar.delegate = self
        self.searchController?.searchBar.tintColor = self.view.tintColor
        self.searchController?.searchBar.searchBarStyle = UISearchBarStyle.minimal
        self.searchController?.searchBar.placeholder = NSLocalizedString("search thing placeholder", comment: "Placeholder for Searchbar in Things list")
        
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let cell = sender as? UITableViewCell else {
            NSLog("Segue without tapping on a cell")
            return
        }
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            NSLog("cell \(cell) not in tableView")
            return
        }
        
        self.searchController?.searchBar.resignFirstResponder()
        
        if segue.identifier == "showThingDetails" {
            let selectedProduct = self.resultsController?.object(at: indexPath)
            
            if let destinationViewController = segue.destination as? EZLThingDetailTableViewController {
                destinationViewController.product = selectedProduct
                destinationViewController.managedObjectContext = self.managedObjectContext
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func createNewProductButtonTapped(_ sender: Any) {
        
        let name = self.searchController?.searchBar.text
        let amount = NSNumber(integerLiteral: 0)
        let onList = NSNumber(booleanLiteral: true)
        let bought = NSNumber(booleanLiteral: false)
        let addedToList = NSNumber(integerLiteral: 1)
        
        let newProduct = Product(entity: Product.entity(), insertInto: managedObjectContext)
        newProduct.name = name
        newProduct.amount = amount
        newProduct.onList = onList
        newProduct.bought = bought
        newProduct.addedToList = addedToList
        
        do {
            try managedObjectContext.save()
            self.tableView.reloadData()
        } catch let error as NSError {
            NSLog("Creating a new product failed due to this reason: \(error.localizedDescription)")
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        for product in self.addedProducts {
            
            let onList = product.onList?.boolValue ?? false
            
            if onList == true {
                product.addedToList = NSNumber(integerLiteral: (product.addedToList?.intValue ?? 0) + 1)
            }
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            NSLog("Couldn't toggle onList: \(error.localizedDescription)")
        }
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Notifications
    
    func categoryOrderChanged(_ notification: Notification) {
        do {
            try self.resultsController?.performFetch()
            self.tableView.reloadData()
        } catch let error as NSError {
            NSLog("Couldn't update category order: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: - UITableViewDataSource
    open override func numberOfSections(in tableView: UITableView) -> Int {
        guard let resultsController = self.resultsController else {
            NSLog("No resultsController!")
            return 0
        }
        
        guard let sections = resultsController.sections else {
            NSLog("No sections")
            return 0
        }
        
        return sections.count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let resultsController = self.resultsController else {
            NSLog("No resultsController!")
            return 0
        }
        
        guard let sections = resultsController.sections else {
            NSLog("No sections")
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "addThingCell"
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        self.configure(cell: cell, at: indexPath)
        
        return cell
        
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        
        guard let resultsController = self.resultsController else {
            NSLog("No resultsController")
            return
        }
        
        let product = resultsController.object(at: indexPath)
        
        if (product.onList?.boolValue ?? false) == true {
            cell.textLabel?.font = Branding.shared.selectedItemFont()
        } else {
            cell.textLabel?.font = Branding.shared.unselectedItemFont()
        }
        
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = product.detailText
        
    }
    
    func toggleOnList(of product: Product) {
        
        let onList = product.onList?.boolValue ?? false
        
        if onList == false && self.addedProducts.contains(product) == false {
            self.addedProducts.append(product)
        } else {
            if let index = self.addedProducts.index(of: product) {
                self.addedProducts.remove(at: index)
            }
        }
        
        product.onList = NSNumber(booleanLiteral: !onList)
        
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            NSLog("Couldn't toggle onList: \(error.localizedDescription)")
        }
    }
        
    //MARK:- UIScrollViewDelegate
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.searchController?.isActive ?? false == true {
            self.searchController?.searchBar.resignFirstResponder()
            self.tableView.becomeFirstResponder()
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    
    //MARK:- UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard SettingsManager.shared.currentSelectionMode() == .Tap else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let resultsController = self.resultsController else {
            NSLog("No resultsController!")
            return
        }
        
        let selectedProduct = resultsController.object(at: indexPath)
        self.toggleOnList(of: selectedProduct)
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if SettingsManager.shared.currentSelectionMode() == .Tap {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.searchController?.searchBar.resignFirstResponder()
        
        let selectedProduct = self.resultsController?.object(at: indexPath)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let productDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "EZLThingDetailTableViewController") as? EZLThingDetailTableViewController {
            productDetailViewController.product = selectedProduct
            productDetailViewController.managedObjectContext = self.managedObjectContext
            self.navigationController?.pushViewController(productDetailViewController, animated: true)
        }
        
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        
        var toggleOnListActionTitle = ""
        
        if (selectedProduct.onList?.boolValue ?? false) == true {
            toggleOnListActionTitle = NSLocalizedString("PRODUCT_LIST.REMOVE", comment: "")
        } else {
            toggleOnListActionTitle = NSLocalizedString("PRODUCT_LIST.ADD", comment: "")
        }
        
        let addToListAction = UIContextualAction(style: .normal, title: toggleOnListActionTitle) { (action, view, completionHandler) in
            
            self.toggleOnList(of: selectedProduct)
            completionHandler(true)
            
//            OperationQueue.main.addOperation {
//                tableView.setEditing(false, animated: true)
//            }
        }
        
        addToListAction.backgroundColor = Branding.shared.actionColor()
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [addToListAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        
        return swipeActionConfiguration
        
    }
    
    //MARK:- NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.delete:
            guard let indexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        case NSFetchedResultsChangeType.update:
            guard let indexPath = indexPath else { return }
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        case NSFetchedResultsChangeType.insert:
            guard let newIndexPath = newIndexPath else { return }
            self.tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.fade)
        case NSFetchedResultsChangeType.move:
            break
        }
    }
    
    
    //MARK: - UISearchResultsUpdating
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        guard let resultsController = self.resultsController else { return }
        
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText == "" {
            let visibleCategoriesOnly = NSPredicate(format: "category.hidden == 0 || category == nil")
            resultsController.fetchRequest.predicate = visibleCategoriesOnly
            self.createNewProductButton.isEnabled = false
        } else {
            // [c] is for case-insensitive
            let searchPrediate = NSPredicate(format: "SELF.name contains [c] '\(searchText)' && (category.hidden == 0 || category == nil)")
            resultsController.fetchRequest.predicate = searchPrediate
            self.createNewProductButton.isEnabled = true
        }
        
        do {
            try resultsController.performFetch()
        } catch let error as NSError {
            NSLog("Couldn't update search results: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - UISearchControllerDelegate
    
    //MARK: - UISearchBarDelegate
    
}
