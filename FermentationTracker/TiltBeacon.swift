//
//  TiltBeacon.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/3/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import CoreBluetooth

// https://kvurd.com/blog/tilt-hydrometer-ibeacon-data-format/
/*
 Red:    A495BB10C5B14B44B5121370F02D74DE
 Green:  A495BB20C5B14B44B5121370F02D74DE
 Black:  A495BB30C5B14B44B5121370F02D74DE
 Purple: A495BB40C5B14B44B5121370F02D74DE
 Orange: A495BB50C5B14B44B5121370F02D74DE
 Blue:   A495BB60C5B14B44B5121370F02D74DE
 Yellow: A495BB70C5B14B44B5121370F02D74DE
 Pink:   A495BB80C5B14B44B5121370F02D74DE
 */

#if !swift(>=4.2)
    public protocol CaseIterable {
        associatedtype AllCases: Collection where AllCases.Element == Self
        static var allCases: AllCases { get }
    }
    extension CaseIterable where Self: Hashable {
        static var allCases: [Self] {
            return [Self](AnySequence { () -> AnyIterator<Self> in
                var raw = 0
                var first: Self?
                return AnyIterator {
                    let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                    if raw == 0 {
                        first = current
                    } else if current == first {
                        return nil
                    }
                    raw += 1
                    return current
                }
            })
        }
    }
#endif

enum TiltColor: Int, CaseIterable { // CaseIterable is in Swift 4.2
    case red = 1, green, black, purple, orange, blue, yellow, pink
    
    func name() -> String {
        return String(reflecting: self).capitalized
    }
}

class TiltBeacon : Beacon {
    let temperature: Float // F
    let significantGravity: Float // SG in
    let color: TiltColor
    private let tiltUUIDFormat = "A495BB%d0-C5B1-4B44-B512-1370F02D74DE"

    // Returns nil if not a tilt Beacon
    override init?(withProximityUUID proximityUUID: CBUUID, majorValue: UInt16, minorValue: UInt16, transmitPower: Int8) {
        // If it is a tilt, then initialize, else return nil
        for tmpColor in TiltColor.allCases {
            let colorUUIDString = String(format: tiltUUIDFormat, tmpColor.rawValue)
            let colorUUID = CBUUID(string: colorUUIDString)
            if colorUUID == proximityUUID {
                self.temperature = Float(majorValue)
                self.significantGravity = Float(minorValue) / 1000.0
                self.color = tmpColor
                super.init(withProximityUUID: proximityUUID, majorValue: majorValue, minorValue: minorValue, transmitPower: transmitPower)
                return // good!
            }
        }
        return nil // bad!
    }
    
    init(withColor color: TiltColor, temperature: Float, signficantGravity: Float, transmitPower: Int8) {
        let colorUUIDString = String(format: tiltUUIDFormat, color.rawValue)
        let colorUUID = CBUUID(string: colorUUIDString)
        self.temperature = temperature
        self.significantGravity = signficantGravity
        self.color = color
        super.init(withProximityUUID: colorUUID, majorValue: UInt16(temperature), minorValue: UInt16(signficantGravity * 1000.0), transmitPower: transmitPower)!

    }
    
}
