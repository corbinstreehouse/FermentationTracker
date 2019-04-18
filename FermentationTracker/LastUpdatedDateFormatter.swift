//
//  LastUpdatedDateFormatter.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/9/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class LastUpdatedDateFormatter: DateFormatter {
    
    override func string(for obj: Any?) -> String? {
        // If the data is within seconds/minutes/hours, say so
        if let date = obj as? Date {
            let timeInterval = Date().timeIntervalSince(date)
            if timeInterval <= 60 {
                // TODO: localize
                return String(format: "%0.1f seconds ago", timeInterval)
            }
            let timeIntervalInMinutes = timeInterval / 60.0
            if timeIntervalInMinutes <= 60 {
                let minuteStr = Int(timeIntervalInMinutes) == 1 ? "minute" : "minutes"
                return String(format: "%d %@ ago", Int(timeIntervalInMinutes), minuteStr)
            }
            let timeIntervalInHours = timeIntervalInMinutes / 60.0
            if timeIntervalInHours < 24 {
                let hourStr = Int(timeIntervalInHours) == 1 ? "hour" : "hours"
                let minuteStr = Int(timeIntervalInMinutes) == 1 ? "minute" : "minutes"
                let partialTimeIntervalInMinutes = timeIntervalInMinutes - Double(Int(timeIntervalInHours))*60.0
                return String(format: "%d %@ %d %@ ago", Int(timeIntervalInHours), hourStr, Int(partialTimeIntervalInMinutes), minuteStr)
            }
        }
        return super.string(for: obj)
    }

}
