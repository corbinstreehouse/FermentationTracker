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
    
    }
    
}
