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
    
    var fermentationDataViewController: FermentationDataViewController?
    
    override func addChildViewController(_ childViewController: NSViewController) {
        if childViewController.isKind(of: FermentationDataViewController.self) {
            fermentationDataViewController = childViewController as? FermentationDataViewController
        }
        super.addChildViewController(childViewController)
    }
    
    override var representedObject: Any? { // [Beer]
        didSet {
            // If a single beer, then pick it out
            var beer: Beer? = nil
            if let beers: [Beer] = representedObject as? [Beer] {
                if beers.count == 1 {
                    beer = beers.first
                }
            }
            fermentationDataViewController?.representedObject = beer
        }
    }
    
    
}
