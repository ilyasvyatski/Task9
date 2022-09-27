//
//  RecordEntity+CoreDataProperties.swift
//  Task7
//
//  Created by neoviso on 9/25/22.
//
//

import Foundation
import CoreData


extension RecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordEntity> {
        return NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
    }

    @NSManaged public var picture: Set<PictureEntity>?

}

// MARK: Generated accessors for picture
extension RecordEntity {

    @objc(addPictureObject:)
    @NSManaged public func addToPicture(_ value: PictureEntity)

    @objc(removePictureObject:)
    @NSManaged public func removeFromPicture(_ value: PictureEntity)

    @objc(addPicture:)
    @NSManaged public func addToPicture(_ values: Set<PictureEntity>)

    @objc(removePicture:)
    @NSManaged public func removeFromPicture(_ values: Set<PictureEntity>)

}
