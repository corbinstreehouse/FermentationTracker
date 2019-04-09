//
//  FermentationDataProvider+Extensions.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/9/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation

extension FermentationDataProvider {
    // For use in NSSortDescriptor
    @objc func compare(_ object2: Any) -> ComparisonResult {
        let dataProvider2 = object2 as! FermentationDataProvider
        // These need to be non-nil
//        let id1 = dataProvider1.identifier!
//        let id2 = dataProvider2.identifier!
//        if id1 == id2 {
            // Go by the name I guess...
            let name1 = self.name!
            let name2 = dataProvider2.name!
            return name1.compare(name2)
//        }
        
    }
}
