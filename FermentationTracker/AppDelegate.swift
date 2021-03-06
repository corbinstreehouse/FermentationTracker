//
//  AppDelegate.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/2/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let bluetoothScanner = TiltBluetoothScanner()
    
    override init() {
        super.init()
        registerDefaults()
    }
    
    private func registerDefaults() {
        // Load our defaults
        let defaultsURL = Bundle.main.resourceURL?.appendingPathComponent("Defaults.plist")
        let defaultsDict = NSDictionary(contentsOf: defaultsURL!)!
        let defaults: [String : Any] = defaultsDict as! [String : Any]
        UserDefaults.standard.register(defaults: defaults)
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        // start watching for tilts
        bluetoothScanner.addFoundTiltHandler { (tilt: TiltBeacon) in
            DispatchQueue.main.async {
                self.handleFoundDevice(tilt)
            }
        }
        bluetoothScanner.startScanning()
    }
    
    private func makeProviderFromDevice(_ device: FermentationDataProviderDevice) -> FermentationDataProvider {
        let provider = FermentationDataProvider(context: self.persistentContainer.viewContext)
        provider.identifier = device.identifier
        provider.name = device.name
        provider.encodedColor = RMEncodedColorTransformer.intFromColor(device.color)
        return provider
    }
    
    private var beerCount = 1
    
    private func addNewBeerForDevice(_ device: FermentationDataProviderDevice) -> Beer {
        disableUndoRegistration()
        let beer = Beer(context: self.persistentContainer.viewContext)
        beer.name = String(format:NSLocalizedString("New Beer %d", comment: "New beer name"), beerCount)
        beerCount = beerCount + 1
        let d = Date()
        beer.dateAdded = d
        beer.creationOrder = Double(d.timeIntervalSinceReferenceDate)
        beer.fermentationDataProvider = makeProviderFromDevice(device)
        beer.isTracking = true
        enableUndoRegistration()
        return beer
    }
    
    private func findTrackingBeerForDevice(_ device: FermentationDataProviderDevice) -> Beer? {
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        // Sort with the newest items on top
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationOrder", ascending: false)]
        // Find all that have a fermentation data provider still associated
        // I hate this string based programming
        fetchRequest.predicate = NSPredicate(format: "isTracking == true && fermentationDataProvider.identifier = %@", device.identifier as CVarArg)
        // use %K?
        
        // We only need the first one
        fetchRequest.fetchLimit = 1
        var beer: Beer? = nil
        self.persistentContainer.viewContext.performAndWait() {
            do {
                let beers = try fetchRequest.execute()
                if beers.count > 0 { // should be one
                    // Take the first one for tracking
                    beer = beers.first
                }
            } catch let error as NSError {
                // TODO: corbin!! better error handling. this shouldn't fail.
                fatalError("Unresolved error \(error)")
            }
        }
        return beer
    }
    
    func disableUndoRegistration() {
        persistentContainer.viewContext.undoManager?.disableUndoRegistration()
    }

    func enableUndoRegistration() {
        persistentContainer.viewContext.undoManager?.enableUndoRegistration()
    }

    func handleFoundDevice(_ device: FermentationDataProviderDevice) {
        let context = persistentContainer.viewContext
        // See if we have this provider already somewhere in our list of active beers; if so, update it; otherwise we will create a new entry
        var beer = findTrackingBeerForDevice(device)
        if beer == nil {
            beer = addNewBeerForDevice(device)
        }
        disableUndoRegistration()
        beer!.addFermentationEntryFor(device: device, context: context)
        enableUndoRegistration()
        silentlySaveContext()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FermentationTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
//                NSApp.presentError(error)
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support

    private func silentlySaveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("silent context save error: \(error)")
            }
        }
    }
    
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(error)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

