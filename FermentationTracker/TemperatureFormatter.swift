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
            return String(format:"%.0°C", cels)
        }
    }
    
    
}
