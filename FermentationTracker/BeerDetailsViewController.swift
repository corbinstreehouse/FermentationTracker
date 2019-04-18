//
//  BeerDetailsViewController.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/6/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class BeerDetailsViewController: NSViewController {
    
    private var observerToken: NSObjectProtocol?
    @IBOutlet var arrayController: NSArrayController!
    
    private func updateSelectedBeers() {
        let beers = self.mainWindowController.selectedBeers
        self.representedObject = beers
        self.arrayController.setSelectedObjects(beers)
    }
    
    var selectedBeer: Beer? {
        get {
            return self.mainWindowController.selectedBeers.first
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.observerToken = NotificationCenter.default.addObserver(forName: MainWindowController.selectedBeersChangedNote, object: self.mainWindowController, queue: nil) { [weak self] (Notification) in
            self?.updateSelectedBeers()
        }
        updateSelectedBeers()
    }
    
    override func viewDidDisappear() {
        if let observerToken = observerToken {
            NotificationCenter.default.removeObserver(observerToken)
            self.observerToken = nil
        }
    }
    
    @IBAction func startOrStopTrackingButtonClicked(_ sender: Any?) {
        if let beer = self.selectedBeer {
            beer.isTracking = !beer.isTracking
        }
    }
    
    // Called when editing the name
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == NSStoryboardSegue.Identifier("NamePopover") {
            // Pass the selected beer for bindings in that view controller
            let vc = segue.destinationController as! NSViewController
            vc.representedObject = self.selectedBeer
        }
    }
    

 
}
