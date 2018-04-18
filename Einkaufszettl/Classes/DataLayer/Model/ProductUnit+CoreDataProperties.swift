//
//  ProductUnit+CoreDataProperties.swift
//  
//
//  Created by Nathan Mattes on 14.05.17.
//
//

import Foundation
import CoreData


extension ProductUnit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductUnit> {
        return NSFetchRequest<ProductUnit>(entityName: "ProductUnit")
    }

    @NSManaged public var name: String?
    @NSManaged public var plural: String?
    @NSManaged public var singular: String?
    @NSManaged public var product: NSOrderedSet?

}

// MARK: Generated accessors for product
extension ProductUnit {

    @objc(insertObject:inProductAtIndex:)
    @NSManaged public func insertIntoProduct(_ value: Product, at idx: Int)

    @objc(removeObjectFromProductAtIndex:)
    @NSManaged public func removeFromProduct(at idx: Int)

    @objc(insertProduct:atIndexes:)
    @NSManaged public func insertIntoProduct(_ values: [Product], at indexes: NSIndexSet)

    @objc(removeProductAtIndexes:)
    @NSManaged public func removeFromProduct(at indexes: NSIndexSet)

    @objc(replaceObjectInProductAtIndex:withObject:)
    @NSManaged public func replaceProduct(at idx: Int, with value: Product)

    @objc(replaceProductAtIndexes:withProduct:)
    @NSManaged public func replaceProduct(at indexes: NSIndexSet, with values: [Product])

    @objc(addProductObject:)
    @NSManaged public func addToProduct(_ value: Product)

    @objc(removeProductObject:)
    @NSManaged public func removeFromProduct(_ value: Product)

    @objc(addProduct:)
    @NSManaged public func addToProduct(_ values: NSOrderedSet)

    @objc(removeProduct:)
    @NSManaged public func removeFromProduct(_ values: NSOrderedSet)

}
