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

protocol PersistentContainerProvider {
    var persistentContainer: NSPersistentContainer { get }
}

extension NSViewController: PersistentContainerProvider {
    var persistentContainer: NSPersistentContainer  {
        get {
            if let parentVC = self.parent {
                return parentVC.persistentContainer
            } else {
                // assumes a relationship..
                let pcp = self.view.window!.windowController as! PersistentContainerProvider
                return pcp.persistentContainer
            }
        }
    }
}

class MainWindowController: NSWindowController, PersistentContainerProvider {
    
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
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()


    private let bluetoothScanner = TiltBluetoothScanner()
    
    override func awakeFromNib() {

    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
        // start watching for tilts
        bluetoothScanner.startScanning()
        bluetoothScanner.addFoundTiltHandler { (tilt: TiltBeacon) in
            self.handleFound(fermentationDataProvider: tilt)
        }
    }
    
    func handleFound(fermentationDataProvider: FermentationDataProvider) {
        // See if we have this provider already somewhere in our list of active beers; if so, update it
//        guard let beers = beerManager.beers else { return }
//        for beer in beers {
//            if beer.fermentationDataProvider?.isEqual(to: fermentationDataProvider) {
//                print("lksdjfds")
//            }
//        }
        
    }
    
    override func windowDidLoad() {
        super.windowWillLoad()
        // so flipping stupid that we can't set this in the UI just because it isn't on an NSVisualEffectView.
        self.window?.appearance = NSAppearance.init(named: NSAppearance.Name.vibrantDark)
    }
    
    
    
    
    
}
