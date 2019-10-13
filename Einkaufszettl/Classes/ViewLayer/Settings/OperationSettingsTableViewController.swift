//
//  OperationSettingsTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 30.11.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class OperationSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SETTINGS.GESTURE", comment: "Bedienung")
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectionMode.allValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationModeTableViewCell", for: indexPath)

        let mode = SelectionMode.allValues[indexPath.row]
        
        cell.textLabel?.text = mode.readableName()
        
        if mode == SettingsManager.shared.currentSelectionMode() {
            cell.textLabel?.font = OldBranding.shared.selectedItemFont()
        } else {
            cell.textLabel?.font = OldBranding.shared.unselectedItemFont()
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            SettingsManager.shared.setSelectionMode(to: SelectionMode.Tap)
        case 1:
            SettingsManager.shared.setSelectionMode(to: SelectionMode.Swipe)
        default:
            break
        }
        
        tableView.reloadData()
    }
}
