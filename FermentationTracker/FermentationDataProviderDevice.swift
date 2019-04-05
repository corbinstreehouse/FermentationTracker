//
//  FermentationDataProviderDevice.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import AppKit

protocol FermentationDataProviderDevice {
    var temperature: Double { get }
    var gravity: Double { get }
    var timestamp: Date { get }
    var description: String { get }
    var color: NSColor { get }
    func isEqual(to: FermentationDataProviderDevice) -> Bool
    
}

