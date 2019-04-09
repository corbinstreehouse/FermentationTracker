//
//  SidebarTableView.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/8/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

//class SidebarTableView: NSTableView {
//
//
//}

// ugh, this kills wantsUpdateLayer=true
class CustomSelectionTableRowView: NSTableRowView {
    var selectionHighlightColor: NSColor = NSColor(named: NSColor.Name("TableRowSelectionHighilghtColor"))!
    
    override func drawSelection(in dirtyRect: NSRect) {
        if self.interiorBackgroundStyle == .dark {
            selectionHighlightColor.set()
        } else {
            NSColor.alternateSelectedControlTextColor.set()
        }
        dirtyRect.fill(using: .sourceOver)
    }
    
}
