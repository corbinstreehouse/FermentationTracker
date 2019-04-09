//
//  RMTableView.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/8/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

// Stuff that NSTableView is missing

class RMTableView: NSTableView {
    
    override func deleteBackward(_ sender: Any?) {
        nextResponder?.try(toPerform: #selector(NSResponder.deleteBackward(_:)), with: sender)
    }
    
    override func keyDown(with event: NSEvent) {
        if let chars = event.charactersIgnoringModifiers {
            switch chars {
            case String(Character(UnicodeScalar(NSBackspaceCharacter)!)):
                deleteBackward(self);
                return;
            case String(Character(UnicodeScalar(NSDeleteCharacter)!)):
                deleteBackward(self);
                return;
            default:
                break;
            }
        }
        super.keyDown(with: event)
    }
    
    
}
