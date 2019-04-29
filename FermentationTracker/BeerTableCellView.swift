//
//  BeerTableCellView.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/9/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class BeerTableCellView: NSTableCellView {
    
    @IBOutlet var dateFormatter: DateFormatter!
    
    override var objectValue: Any? {
        didSet(oldValue) {
            if let oldValue = oldValue as? NSObject {
                oldValue.removeObserver(self, forKeyPath: Beer.dateLastUpdatedPropertyName)
            }
            if let newValue = objectValue as? NSObject {
                newValue.addObserver(self, forKeyPath: Beer.dateLastUpdatedPropertyName, options: NSKeyValueObservingOptions.new, context: nil)
            }
        }
    }
    
    private func updateDateFormatterFor(date: Date) {
        if Calendar.current.isDateInToday(date) {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        } else {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .short
        }
    }
    
    // Update the formatter style dpending on the date..
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        if keyPath == Beer.dateLastUpdatedPropertyName {
            let beer = object as! Beer
            // Might be nil for bad data...
            if let date = beer.dateLastUpdated {
                updateDateFormatterFor(date: date)
            }
        }
    }

    
}
