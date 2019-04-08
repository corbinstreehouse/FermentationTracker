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
    
    static let selectedBeersChangedNote = NSNotification.Name("SelectedBeersChanged")
    var selectedBeers: [Beer] = [] {
        didSet {
            notifySelectedBeersObservers()
        }
    }
    private func notifySelectedBeersObservers() {
        NotificationCenter.default.post(name: MainWindowController.selectedBeersChangedNote, object: self)
    }
    
    
    override func awakeFromNib() {
        // Start the persistentContainer load?
        self.window?.contentView?.wantsLayer = true
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let color = NSColor(named: NSColor.Name("WindowBackgroundColor"))
        self.window?.backgroundColor = color // NSColor(catalogName: "Media", colorName: <#T##NSColor.Name#>)
        // so flipping stupid that we can't set this in the UI just because it isn't on an NSVisualEffectView.
//        self.window?.appearance = NSAppearance.init(named: NSAppearance.Name.vibrantDark)
    }
    
    
    
    
    
    
}
