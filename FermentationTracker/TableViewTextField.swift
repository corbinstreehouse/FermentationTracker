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
}
