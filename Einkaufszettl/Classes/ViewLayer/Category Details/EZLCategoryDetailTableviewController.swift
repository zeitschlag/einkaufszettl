//
//  EZLCategoryDetailTableviewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 29.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit

extension EZLCategoryDetailTableViewController: @preconcurrency EZLButtonTableViewCellDelegate {
    func buttonTapped(sender: Any) {
        
        let title = String(format: NSLocalizedString("REMOVE.%@.IRREVOCABLY", comment: ""), self.category.name ?? "")
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL.NO", comment:"No"), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: NSLocalizedString("GENERAL.YES", comment:"Yes"), style: .destructive) { (_) in
            
            self.managedObjectContext.delete(self.category)
            
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Coudln't save: \(error.localizedDescription)")
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
}
