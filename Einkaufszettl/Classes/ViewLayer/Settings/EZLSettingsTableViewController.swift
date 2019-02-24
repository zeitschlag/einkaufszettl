//
//  EZLSettingsTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 09.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit
import CoreData

class EZLSettingsTableViewController: UITableViewController {
    
    // Move to enum    
    let settings : [[String]] = [
        [
            NSLocalizedString("SETTINGS.CATEGORY_DISPLAY_ORDER", comment: "Reihenfolge"),
            NSLocalizedString("SETTINGS.HIDE_CATEGORIES", comment: "Hide Categories")
        ],
        [
            NSLocalizedString("SETTINGS.GESTURE", comment: "Bedienung"),
            NSLocalizedString("SETTINGS.SHORT_SHARING", comment: "Kurzer Sharing-Text")
        ],
        [
            NSLocalizedString("SETTINGS.LICENSES", comment: "Licenses")
        ]
    ]
    
    var managedObjectContext : NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
    
    let operationSettingsTableViewControllerIdentifier = "OperationSettingsTableViewController"
    let licenseViewControllerIdentifier = "licenseViewControllerIdentifier"
    let categoryOrderViewControllerIdentifier = "categoryOrderViewControllerIdentifier"
    let categoryVisibilityViewControllerIdentifier = "categoryVisibilityViewControllerIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SETTINGS.TITLE", comment: "Settings")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let settingsCellIdentifier = "settingsCell"
        
        //TODO: New Cell for Gesture-Setting. This cell has a title and a detail label
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = self.settings[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch (indexPath.section) {
            
        case 0:
            switch (indexPath.row) {
            case 0:
                let categoryOrderViewController = mainStoryboard.instantiateViewController(withIdentifier: categoryOrderViewControllerIdentifier) as! EZLCategoryOrderTableViewController
                categoryOrderViewController.managedObjectContext = self.managedObjectContext
                self.navigationController?.pushViewController(categoryOrderViewController, animated: true)
            case 1:
                let categoryVisibilityViewController = mainStoryboard.instantiateViewController(withIdentifier: categoryVisibilityViewControllerIdentifier) as! EZLCategoryVisbilityTableViewController
                categoryVisibilityViewController.managedObjectContext = self.managedObjectContext
                self.navigationController?.pushViewController(categoryVisibilityViewController, animated: true)
                
            default: break
            }
            
        case 1:
            switch (indexPath.row) {
            case 0:
                
                let operationSettingsTableViewController = mainStoryboard.instantiateViewController(withIdentifier: operationSettingsTableViewControllerIdentifier) as! OperationSettingsTableViewController
                
                self.navigationController?.pushViewController(operationSettingsTableViewController, animated: true)
                
                
            case 1:
                let sharingTextViewController = mainStoryboard.instantiateViewController(withIdentifier: SharingTextViewController.identifier) as! SharingTextViewController
                
                self.navigationController?.pushViewController(sharingTextViewController, animated: true)
                
                break
            default:
                break
            }
            
        case 2:
            switch (indexPath.row) {
            case 0:
                let licenseViewController = mainStoryboard.instantiateViewController(withIdentifier: licenseViewControllerIdentifier)
                self.navigationController?.pushViewController(licenseViewController, animated: true)
            default:
                break
            }
        default: break
            
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        guard section == 2 else {
            return nil
        }
        
        let bundleVersionKey = "CFBundleShortVersionString"
        let bundleBuildKey = "CFBundleVersion"
        
        guard let infoDict = Bundle.main.infoDictionary, let versionString = infoDict[bundleVersionKey] as? String, let buildString = infoDict[bundleBuildKey] as? String else {
            return nil
        }
        
        let localizedString = NSLocalizedString("SETTINGS.VERSION.%@", comment: "")
        
        return String(format: localizedString, versionString, buildString)
    }
    
    // MARK : Actions
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
