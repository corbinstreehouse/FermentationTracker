//
//  DebugTextFieldCell.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/8/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

class DebugTextFieldCell: NSTextFieldCell {
    
    override var textColor: NSColor? {
        get {
            return super.textColor
        }
        set (value) {
            super.textColor = value
        }
    }
}
