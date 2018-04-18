//
//  Product+CoreDataClass.swift
//  
//
//  Created by Nathan Mattes on 14.05.17.
//
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {

    var categoryName : String {
        get {
            guard let category = self.category else {
                return NSLocalizedString("no_category", comment: "This text appears in SectionTitle, if there's no category")
            }
            
            return category.name ?? ""
        }
    }

    var detailText: String {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            guard let amount = self.amount, amount.doubleValue > 0.0 else { return " " }
            
            guard let amountString = numberFormatter.string(from: amount) else {
                NSLog("Couldn't format \(amount)")
                return ""
            }
            
            if let unit = self.unit {
                return "\(amountString) \(unit.name ?? "")"
            } else {
                return amountString
            }

        }
    }

}
