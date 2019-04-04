//
//  FermentationTrackerApplication.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class FermentationTrackerApplication: NSApplication {
    
    static var appDelegate: AppDelegate = {
        return NSApp.delegate as! AppDelegate
    }()
    
}
