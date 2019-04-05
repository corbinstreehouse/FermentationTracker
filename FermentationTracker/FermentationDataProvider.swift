//
//  FermentationDataProvider.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

protocol FermentationDataProvider {
    var temperature: Float { get }
    var significantGravity: Float { get }
    var timestamp: Date { get }
    var description: String { get }
    var color: NSColor { get }
    func isEqual(to: FermentationDataProvider) -> Bool
    
}

