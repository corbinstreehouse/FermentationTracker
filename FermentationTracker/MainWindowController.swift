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
import CSV

extension NSError {
    static let fermentationTrackerErrorDomain = "com.redwoodmonkey.FermentationTracker"
}


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
    
    private func verifyFormatForCSV(_ csv: CSVReader) throws {
        // Verify the header row is our format
        let headerRow = csv.headerRow!
        if headerRow.count != 7 {
            let errorDesc = String(format: "Incorrect CSV format; expecting 7 rows in the header but found %d.", headerRow.count)
            throw NSError(domain: NSError.fermentationTrackerErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: errorDesc])
        }
        let expectedHeader = ["Timestamp", "Timepoint", "SG", "Temp", "Color", "Beer", "Comment"]
        for i in 0 ..< headerRow.count {
            if headerRow[i] != expectedHeader[i] {
                let errorDesc = String(format: "Incorrect CSV format; expecting %@ but found %@ at column %d.", expectedHeader[i], headerRow[i], i+1)
                throw NSError(domain: NSError.fermentationTrackerErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: errorDesc])
            }
        }

    }
    
    private func makeProviderFromColorName(_ colorName: String) -> FermentationDataProvider {
        let provider = FermentationDataProvider(context: self.persistentContainer.viewContext)

        for tiltColor in TiltColor.allCases {
            if tiltColor.name().caseInsensitiveCompare(colorName) == .orderedSame {
                let colorUUIDString = String(format: TiltBeacon.tiltUUIDFormat, tiltColor.rawValue)

                provider.identifier = UUID(uuidString: colorUUIDString)
                provider.name = tiltColor.name() + " Tilt"
                provider.encodedColor = RMEncodedColorTransformer.intFromColor(tiltColor.nsColor())
                return provider
            }
        }
    
        // unknown provider!
        provider.identifier = UUID()
        provider.name = String(format: "%@ Device", colorName) // TODO: localize
        provider.encodedColor = RMEncodedColorTransformer.intFromColor(NSColor.black)
        return provider
    }
    
    private func importCSVFrom(url: URL) {
        let context = persistentContainer.viewContext
        let undoManager = self.window!.undoManager!
        undoManager.beginUndoGrouping()

        let stream = InputStream(url: url)!
        do {
            let csv = try CSVReader(stream: stream, hasHeaderRow: true)
            try verifyFormatForCSV(csv)
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "M-dd-yyyy H:mm:ss a"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            // Go to the first row
            let row = csv.next()!
            
            let beerName = row[5]
            let gravity = Double(row[2])!
            let temp = Double(row[3])!
            let date = dateFormatter.date(from: row[0])!
            let colorName = row[4]
            
            let beer = Beer(context: self.persistentContainer.viewContext)
            beer.name = beerName
            beer.dateAdded = date
            beer.creationOrder = Double(Date().timeIntervalSinceReferenceDate)
            beer.fermentationDataProvider = makeProviderFromColorName(colorName)
            beer.isTracking = false // an import
            beer.dateLastUpdated = date

            beer.addFermentationEntryFor(gravity: gravity, temperature: temp, timestamp: date, context: context)

            while let row = csv.next() {
                let gravity = Double(row[2])!
                let temp = Double(row[3])!
                let date = dateFormatter.date(from: row[0])!
                beer.addFermentationEntryFor(gravity: gravity, temperature: temp, timestamp: date, context: context)

            }
            
            // TODO: Select that new beer
            
            
        } catch let error as NSError {
            NSApp.presentError(error, modalFor: self.window!, delegate: nil, didPresent: nil, contextInfo: nil)
        }
        
        undoManager.endUndoGrouping()
    }
    
    override func awakeFromNib() {

    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        return FermentationTrackerApplication.appDelegate.persistentContainer
    }()
    
    func ensureUndoManager() {
        if persistentContainer.viewContext.undoManager == nil {
            persistentContainer.viewContext.undoManager = UndoManager()
        }
    }
    
    @objc func windowWillReturnUndoManager(_ window: NSWindow) -> UndoManager? {
        ensureUndoManager()
        return persistentContainer.viewContext.undoManager!
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let color = NSColor(named: NSColor.Name("WindowBackgroundColor"))
        self.window?.backgroundColor = color // NSColor(catalogName: "Media", colorName: <#T##NSColor.Name#>)
    }
    
    
}
