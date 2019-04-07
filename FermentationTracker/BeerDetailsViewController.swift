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

    override func viewDidAppear() {
        super.viewDidAppear()
        self.observerToken = NotificationCenter.default.addObserver(forName: MainWindowController.selectedBeersChangedNote, object: self.mainWindowController, queue: nil) { (Notification) in
            self.representedObject = self.mainWindowController.selectedBeers
        }
        self.representedObject = self.mainWindowController.selectedBeers
    }
    
    override func viewDidDisappear() {
        if let observerToken = observerToken {
            NotificationCenter.default.removeObserver(observerToken)
            self.observerToken = nil
        }
    }
}
