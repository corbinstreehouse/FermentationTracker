//
//  Beer+CustomProperties.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/9/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

extension Beer {
    
    static let dateLastUpdatedPropertyName = "dateLastUpdated"
    
    private func addAndUpdateToFermentationEntries(_ entry: FermentationEntry) {
        self.addToFermentationEntries(entry)
        
        // Update our stats for this beer so we don't have to look at the last entry to find out what it is at. Or, maybe that is fine, and things could be simplified.
        self.gravity = entry.gravity
        self.temperature = entry.temperature
        self.dateLastUpdated = entry.timestamp
    }
    
    func addFermentationEntryFor(device: FermentationDataProviderDevice, context: NSManagedObjectContext) {
        addFermentationEntryFor(gravity: device.gravity, temperature: device.temperature, timestamp: device.timestamp, context: context)
    }
    
    func addFermentationEntryFor(gravity: Double, temperature: Double, timestamp: Date, context: NSManagedObjectContext) {
        let f: FermentationEntry = FermentationEntry(context: context)
        f.gravity = gravity
        f.temperature = temperature
        f.timestamp = timestamp
        self.addAndUpdateToFermentationEntries(f)
    }


    @objc var trackingButtonTitle: String {
        if self.isTracking {
            return "Stop Tracking"
        } else {
            return "Start Tracking"
        }
    }
    
    @objc class func keyPathsForValuesAffectingTrackingButtonTitle() -> Set<AnyHashable> {
        return Set<AnyHashable>(["isTracking"])
    }


    
}
