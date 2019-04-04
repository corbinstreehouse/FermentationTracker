//
//  Beer+CoreDataProperties.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//
//

import Foundation
import CoreData


extension Beer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Beer> {
        return NSFetchRequest<Beer>(entityName: "Beer")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var fermentationEntries: NSOrderedSet?

}

// MARK: Generated accessors for fermentationEntries
extension Beer {

    @objc(insertObject:inFermentationEntriesAtIndex:)
    @NSManaged public func insertIntoFermentationEntries(_ value: FermentationEntry, at idx: Int)

    @objc(removeObjectFromFermentationEntriesAtIndex:)
    @NSManaged public func removeFromFermentationEntries(at idx: Int)

    @objc(insertFermentationEntries:atIndexes:)
    @NSManaged public func insertIntoFermentationEntries(_ values: [FermentationEntry], at indexes: NSIndexSet)

    @objc(removeFermentationEntriesAtIndexes:)
    @NSManaged public func removeFromFermentationEntries(at indexes: NSIndexSet)

    @objc(replaceObjectInFermentationEntriesAtIndex:withObject:)
    @NSManaged public func replaceFermentationEntries(at idx: Int, with value: FermentationEntry)

    @objc(replaceFermentationEntriesAtIndexes:withFermentationEntries:)
    @NSManaged public func replaceFermentationEntries(at indexes: NSIndexSet, with values: [FermentationEntry])

    @objc(addFermentationEntriesObject:)
    @NSManaged public func addToFermentationEntries(_ value: FermentationEntry)

    @objc(removeFermentationEntriesObject:)
    @NSManaged public func removeFromFermentationEntries(_ value: FermentationEntry)

    @objc(addFermentationEntries:)
    @NSManaged public func addToFermentationEntries(_ values: NSOrderedSet)

    @objc(removeFermentationEntries:)
    @NSManaged public func removeFromFermentationEntries(_ values: NSOrderedSet)

}
