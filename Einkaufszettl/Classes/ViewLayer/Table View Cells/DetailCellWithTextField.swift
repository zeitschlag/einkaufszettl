//
//  DetailCellWithTextField.swift
//  Einkaufszettl
//
//  Created by Nathan Mattes on 31.10.16.
//  Copyright © 2016 Nathan Mattes. All rights reserved.
//

import UIKit

class DetailCellWithTextField : UITableViewCell {
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    var isNumeric = false
    var isDecimalNumeric = false
    
}

extension DetailCellWithTextField : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //FIXME: This function is a mess!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return false
        }
        
        guard let seperator = NumberFormatter().decimalSeparator else {
            return false
        }

        if self.isNumeric == true || self.isDecimalNumeric == true {
            
            let fullText = textFieldText + string
            
            if self.isDecimalNumeric == true {
                let currentText = textFieldText.trimmingCharacters(in: CharacterSet.whitespaces)

                if fullText == seperator {
                    textField.text = "0\(seperator)"
                    return false
                }

                if (fullText.range(of: "\(seperator)\(seperator)") != nil) {
                    textField.text = fullText.replacingOccurrences(of: "\(seperator)\(seperator)", with: seperator)
                    return false
                }

                let dots = fullText.components(separatedBy: seperator)
                if (dots.count > 2) {
                    textField.text = currentText
                    return false
                }
                
                if fullText.characters.count == 2 &&
                    fullText.characters.first == "0" &&
                    fullText != "0" {
                    let index = fullText.characters.index(fullText.startIndex, offsetBy: 1)
                    let substring = fullText[index]
                    if String(substring) != seperator {
                        textField.text = "\(substring)"
                    } else {
                        return true
                    }
                    
                    return false
                    
                }
            }
        }
        
        return true
    }

}
