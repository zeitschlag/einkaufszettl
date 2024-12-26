//
//  EZLThingDetailTableViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 24.05.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import Foundation

extension EZLThingDetailTableViewController: @preconcurrency EZLButtonTableViewCellDelegate {
    func buttonTapped(sender: Any) {

        let title = String(format: NSLocalizedString("REMOVE.%@.IRREVOCABLY", comment: ""), self.product.name ?? "")
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL.NO", comment:"No"), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: NSLocalizedString("GENERAL.YES", comment:"Yes"), style: .destructive) { (_) in
            
            self.managedObjectContext.delete(self.product)
            
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Coudln't save: \(error.localizedDescription)")
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        if let presentedViewController = self.presentedViewController {
            presentedViewController.present(alertController, animated: true, completion: nil)
        } else {
            self.present(alertController, animated: true, completion: nil)
        }

    }
}
