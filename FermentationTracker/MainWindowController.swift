//
//  MainWindowController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class MainWindowController : NSWindowController {
    override func windowDidLoad() {
        self.window?.appearance = NSAppearance.init(named: NSAppearance.Name.vibrantDark)
    }
    
}
