//
//  GravityFormatter.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/7/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation

class GravityFormatter: Formatter {
    
    override func string(for obj: Any?) -> String? {
        //        if UserDefaults.standard.bool(forKey: Settings.useFahrenheit) // TODO: Plato
        let value = obj as! Double
        return String(format:"%1.3f", value)
    }
    
}
