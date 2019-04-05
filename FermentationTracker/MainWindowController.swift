//
//  MainWindowController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit
import CoreData

class MainWindowController: NSWindowController {
    
//    lazy var persistentContainer: NSPersistentContainer = {
//        return FermentationTrackerApplication.appDelegate.persistentContainer
//    }()
    
    override func awakeFromNib() {
        // Start the persistentContainer load?
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    
    override func windowDidLoad() {
        super.windowWillLoad()
        // so flipping stupid that we can't set this in the UI just because it isn't on an NSVisualEffectView.
//    Gt    self.window?.appearance = NSAppearance.init(named: NSAppearance.Name.vibrantDark)
    }
    
    
    
    
    
}
