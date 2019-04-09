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
    
    func addFermentationEntryForDevice(_ device: FermentationDataProviderDevice, context: NSManagedObjectContext) {
        let f: FermentationEntry = FermentationEntry(context: context)
        
        f.gravity = device.gravity
        f.temperature = device.temperature
        f.timestamp = device.timestamp
        self.addToFermentationEntries(f)
        // Update our stats for this beer so we don't have to look at the last entry to find out what it is at. Or, maybe that is fine, and things could be simplified.
        self.gravity = device.gravity
        self.temperature = device.temperature
        self.dateLastUpdated = device.timestamp
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
