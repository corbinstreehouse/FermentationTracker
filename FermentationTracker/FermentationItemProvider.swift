//
//  FermentationItemProvider.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/4/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation

protocol FermentationItemProvider {
    var temperature: Float { get }
    var significantGravity: Float { get }
    var timestamp: Date { get }
    
}

