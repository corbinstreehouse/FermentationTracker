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
    
    @IBAction func importAction(_ sender: AnyObject?) {
        let o = NSOpenPanel()
        o.allowsMultipleSelection = false
        o.allowedFileTypes = ["csv"]
        
        o.beginSheetModal(for: self.window!) { [weak self] (modalResponse: NSApplication.ModalResponse) in
            if (modalResponse == NSApplication.ModalResponse.OK) {
                self?.importCSVFrom(url: o.url!)
            }
        }
    }
    
    private func importCSVFrom(url: URL) {
        
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
