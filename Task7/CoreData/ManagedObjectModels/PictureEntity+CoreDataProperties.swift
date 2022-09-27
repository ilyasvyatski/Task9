//
//  PictureEntity+CoreDataProperties.swift
//  Task7
//
//  Created by neoviso on 9/25/22.
//
//

import Foundation
import CoreData


extension PictureEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureEntity> {
        return NSFetchRequest<PictureEntity>(entityName: "PictureEntity")
    }

    @NSManaged public var points: Line?
    @NSManaged public var color: NSObject?
    @NSManaged public var width: Float
    @NSManaged public var lines: NSSet?
    @NSManaged public var record: RecordEntity?

}

// MARK: Generated accessors for lines
extension PictureEntity {

    @objc(addLinesObject:)
    @NSManaged public func addToLines(_ value: NSManagedObject)

    @objc(removeLinesObject:)
    @NSManaged public func removeFromLines(_ value: NSManagedObject)

    @objc(addLines:)
    @NSManaged public func addToLines(_ values: NSSet)

    @objc(removeLines:)
    @NSManaged public func removeFromLines(_ values: NSSet)

}
