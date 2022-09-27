//
//  ItemEntity+CoreDataProperties.swift
//  Task7
//
//  Created by neoviso on 9/25/22.
//
//

import Foundation
import CoreData

extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var children: Set<ItemEntity>?
    @NSManaged public var parent: ItemEntity?

}

// MARK: Generated accessors for children
extension ItemEntity {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: ItemEntity)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: ItemEntity)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: Set<ItemEntity>)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: Set<ItemEntity>)

}

extension ItemEntity : Identifiable {

}
