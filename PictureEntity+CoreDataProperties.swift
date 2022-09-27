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

    @NSManaged public var lines: [Line]
    @NSManaged public var record: RecordEntity?
}
