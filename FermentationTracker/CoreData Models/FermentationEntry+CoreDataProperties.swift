//
//  FermentationEntry+CoreDataProperties.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension FermentationEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FermentationEntry> {
        return NSFetchRequest<FermentationEntry>(entityName: "FermentationEntry")
    }

    @NSManaged public var gravity: Float
    @NSManaged public var temperature: Float
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var beer: Beer?

}
