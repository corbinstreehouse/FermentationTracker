//
//  StandardExtensions.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/3/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation


extension Data {
    
    //    init<T>(from value: T) {
    //        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    //    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
    func to<T>(type: T.Type, in range: Range<Data.Index>) -> T {
        return self.subdata(in: range).to(type: type)
    }
}
