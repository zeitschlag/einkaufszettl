//
//  EZLLicenseViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 12.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit

class EZLLicenseViewController: UIViewController {

    @IBOutlet weak var licensesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SETTINGS.LICENSES.TITLE", comment: "Licenses")
        
        guard let file = Bundle.main.path(forResource: "Licenses", ofType: "txt") else {
            return
        }
        
        do {
            let prefixText = NSLocalizedString("SETTINGS.LICENCE.TEXT.PREFIX", comment: "")
            let licenceText = try String(contentsOfFile: file)
            let text =  prefixText + "\n\n" + licenceText
            self.licensesTextView.text = text as String
        } catch {
            print("Error reading the license-file!")
        }
    }

}
