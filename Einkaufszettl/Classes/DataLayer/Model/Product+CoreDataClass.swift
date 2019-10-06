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

    @objc var categoryName : String {
        get {
            guard let category = self.category else {
                return NSLocalizedString("no_category", comment: "This text appears in SectionTitle, if there's no category")
            }
            
            return category.name ?? ""
        }
    }

    var detailText: String? {
        get {
            return self.amountAndUnit
        }
    }

    var amountAndUnit: String? {
        get {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            guard let amount = self.amount, amount.doubleValue > 0.0 else { return nil }
            guard let amountString = numberFormatter.string(from: amount) else { return nil }
            
            if let unit = self.unit {
                let unitString: String

                if amount == 1 {
                    unitString = unit.singular ?? unit.name ?? ""
                } else {
                    unitString =  unit.plural ?? unit.name ?? ""
                }
                return "\(amountString) \(unitString)"
            } else {
                return amountString
            }

        }
    }

}
