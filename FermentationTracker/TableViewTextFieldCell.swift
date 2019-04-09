//
//  TableViewTextField.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/8/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

// Custom text colors don't automagically invert.
class TableViewTextFieldCell: NSTextFieldCell {
    
    private var previousTextColor: NSColor?
    
    // Super newbie mistake of forgetting to implement copyWithZone; why would we need it if we aren't using a cell-based NSTableView?  This shouldn't be needed..but apparently NSTextFieldCell's baseline measurement with autolayout does a copy! who would have guessed. NSCell's implementation does a NSCopyObject, which doesn't retain ivars
    override func copy(with zone: NSZone? = nil) -> Any {
        let result: TableViewTextFieldCell = super .copy(with: zone) as! TableViewTextFieldCell
        if let previousTextColor = result.previousTextColor {
            // Add the needed retain now
            let _ = Unmanaged<NSColor>.passRetained(previousTextColor)
        }
        return result
    }
    
    override var backgroundStyle: NSView.BackgroundStyle {
        get {
            return super.backgroundStyle
        }
        set(newBackgroundStyle) {
            // If we are going to light because we are selected, save off the old color so we can restore it
            if self.backgroundStyle == .light && newBackgroundStyle == .dark {
                previousTextColor = self.textColor
                self.textColor = NSColor.white // or a named color?
            } else if self.backgroundStyle == .dark && newBackgroundStyle == .light {
                if previousTextColor != nil {
                    self.textColor = previousTextColor
                    previousTextColor = nil
                }
            }
            super.backgroundStyle = newBackgroundStyle
            
        }
    }
    
//    deinit {
//        var t = self.textColor
//        withUnsafePointer(to: &t) {
//            print("\(self.stringValue) : textColor.address: \($0)")
//        }
//        NSLog("%@ - %p", self.stringValue, self.textColor!)
//    }
    
//    override var objectValue: Any? {
//        didSet {
//            if let f = self.formatter {
//                if f.isKind(of: TemperatureFormatter.self) {
//                    print("\(self.stringValue)")
//                }
//            }
//        }
//    }
}
