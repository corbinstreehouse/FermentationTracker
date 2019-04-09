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
//        self.window?.contentView?.wantsLayer = true // needed?
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        return FermentationTrackerApplication.appDelegate.persistentContainer
    }()
    
    @objc func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
        if persistentContainer.viewContext.undoManager == nil {
            persistentContainer.viewContext.undoManager = UndoManager()
        }
        return persistentContainer.viewContext.undoManager!
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let color = NSColor(named: NSColor.Name("WindowBackgroundColor"))
        self.window?.backgroundColor = color // NSColor(catalogName: "Media", colorName: <#T##NSColor.Name#>)
    }
    
    
}
