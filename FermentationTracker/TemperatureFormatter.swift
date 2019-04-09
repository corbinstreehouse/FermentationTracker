//
//  TemperatureFormatter.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/6/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation

// C of F, what yah want
class TemperatureFormatter: Formatter {
    
    override func string(for obj: Any?) -> String? {
        let value = obj as! Double
        if UserDefaults.standard.bool(forKey: Settings.useFahrenheit) {
            return String(format:"%.0f℉", value)
        } else {
            // (32°F − 32) × 5/9 = 0°C
            let cels = value - 32 * 5/9
            return String(format:"%.0f°C", cels)
        }
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        // Autolayout will do some formatting with generic strings (ie: "Wj") to measure the size.
        // This causes problems unless we implement this method and do something.
        if string == "Wj" {
//            obj?.pointee = self.string(for: 70.0) as AnyObject?
            obj?.pointee = NSNumber(floatLiteral: 70.0)
            return true
//            return true
        }
        return false
    }

    
    
}
