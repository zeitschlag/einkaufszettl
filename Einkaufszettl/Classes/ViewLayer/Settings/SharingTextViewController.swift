//
//  SharingTextViewController.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 24.02.19.
//  Copyright © 2019 Nathan Mattes. All rights reserved.
//

import UIKit

class SharingTextViewController: UIViewController {
    
    static let identifier = "SharingTextViewController"
    
    @IBOutlet weak var shortTextEnabledLabel: UILabel!
    @IBOutlet weak var shortTextEnabled: UISwitch!
    @IBOutlet weak var shortTextExplanationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SETTINGS.SHORT_SHARING", comment: "")
        self.shortTextEnabledLabel.text = NSLocalizedString("SETTINGS.SHORT_SHARING.ENABLE", comment: "")
        self.shortTextExplanationLabel.text = NSLocalizedString("SETTINGS.SHORT_SHARING.EXPLANATION", comment: "")
        
        self.shortTextEnabled.isOn = SettingsManager.shared.sharingTextDisabled()
    }
    @IBAction func toggleShortTextEnabled(_ sender: Any) {
        SettingsManager.shared.setDisabledSharingText(to: shortTextEnabled.isOn)
    }
}
