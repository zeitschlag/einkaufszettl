//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Nathan Mattes on 14.05.17.
//
//

import Foundation
import CoreData


extension Product {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
//        return NSFetchRequest<Product>(entityName: "Product")
//    }

    @NSManaged public var addedToList: NSNumber?
    @NSManaged public var amount: NSNumber?
    @NSManaged public var bought: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var onList: NSNumber?
    @NSManaged public var category: ProductCategory?
    @NSManaged public var unit: ProductUnit?

}
