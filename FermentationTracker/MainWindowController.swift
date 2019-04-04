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
    
    // I have one model and each window controller could represent the same data in different windows, or it could have a unique BeerManager to show a particular collection of beers (in the future, if i wanted). we use the default container for now.
//    private var persistentContainer: NSPersistentContainer {
//        return FermentationTrackerApplication.appDelegate.persistentContainer
//    }
//
    private var beerManager: BeerManager!

    override func awakeFromNib() {
        // Initialize things
        beerManager = FermentationTrackerApplication.appDelegate.sharedBeerManager
    }
    
    override func windowWillLoad() {
        super.windowWillLoad()
        // start watching for tilts
        TiltBluetoothScanner.sharedScanner.addFoundTiltHandler { (tilt: TiltBeacon) in
            self.handleFound(tilt: tilt)
        }
    }
    
    func handleFound(tilt: TiltBeacon) {
        
    }
    
    override func windowDidLoad() {
        super.windowWillLoad()
        // so flipping stupid that we can't set this in the UI just because it isn't on an NSVisualEffectView.
        self.window?.appearance = NSAppearance.init(named: NSAppearance.Name.vibrantDark)
    }
    
    
    
    
    
}
