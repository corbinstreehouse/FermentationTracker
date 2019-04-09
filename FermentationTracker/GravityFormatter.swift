//
//  GravityFormatter.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/7/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation

class GravityFormatter: Formatter {
    
    @objc var includeGravityType: Bool = false
    
    override func string(for obj: Any?) -> String? {
        //        if UserDefaults.standard.bool(forKey: Settings.useFahrenheit) // TODO: Plato
        let value = obj as! Double
        if includeGravityType {
            return String(format:"%1.3f SG", value)
        } else {
            return String(format:"%1.3f", value)
        }
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        // Autolayout will do some formatting with generic strings (ie: "Wj") to measure the size.
        // This causes problems unless we implement this method and do something.
        if string == "Wj" {
            obj?.pointee = NSNumber(floatLiteral: 1.005)
            return true
        }
        return false
    }

}
