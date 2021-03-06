//
//  TiltBeacon.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/3/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import CoreBluetooth
import AppKit

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
        switch self {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .black:
            return "Black"
        case .purple:
            return "Purple"
        case .orange:
            return "Orange"
        case .blue:
            return "Blue"
        case .yellow:
            return "Yellow"
        case .pink:
            return "Pink"
        }
    }
    func nsColor() -> NSColor {
        // Maybe a better way of doing this?
        switch self {
        case .red:
            return NSColor.red
        case .green:
            return NSColor.green
        case .black:
            return NSColor.black
        case .purple:
            return NSColor.purple
        case .orange:
            return NSColor.orange
        case .blue:
            return NSColor.blue
        case .yellow:
            return NSColor.yellow
        case .pink:
            return NSColor.systemPink
        }
    }
}

class TiltBeacon : Beacon, FermentationDataProviderDevice {
    let temperature: Double // F
    let gravity: Double // SG in
    let name: String
    let color: NSColor
    
    var identifier: UUID {
        get {
            return UUID(uuidString: self.proximityUUID.uuidString)!
        }
    }
    
    let tiltColor: TiltColor
    static let tiltUUIDFormat = "A495BB%d0-C5B1-4B44-B512-1370F02D74DE"

    // Returns nil if not a tilt Beacon
    override init?(withProximityUUID proximityUUID: CBUUID, majorValue: UInt16, minorValue: UInt16, transmitPower: Int8) {
        // If it is a tilt, then initialize, else return nil
        for tiltColor in TiltColor.allCases {
            let colorUUIDString = String(format: TiltBeacon.tiltUUIDFormat, tiltColor.rawValue)
            let colorUUID = CBUUID(string: colorUUIDString)
            if colorUUID == proximityUUID {
                self.temperature = Double(majorValue)
                self.gravity = Double(minorValue) / 1000.0
                self.tiltColor = tiltColor
                self.name = String(format: NSLocalizedString("Tilt %@", comment: "Tilt color format"), tiltColor.name())
                self.color = tiltColor.nsColor()
                super.init(withProximityUUID: proximityUUID, majorValue: majorValue, minorValue: minorValue, transmitPower: transmitPower)
                return // good!
            }
        }
        return nil // bad!
    }
    
    convenience init(withColor color: TiltColor, temperature: Double, signficantGravity: Double, transmitPower: Int8) {
        let colorUUIDString = String(format: TiltBeacon.tiltUUIDFormat, color.rawValue)
        let colorUUID = CBUUID(string: colorUUIDString)
        // should never fail, so bang!
        self.init(withProximityUUID: colorUUID, majorValue: UInt16(temperature), minorValue: UInt16(signficantGravity * 1000.0), transmitPower: transmitPower)!

    }
    
    // tilts are equal if the UUID is the same, and that is it. The major/minor is used for data.
    public static func ==(lhs: TiltBeacon, rhs: TiltBeacon) -> Bool {
        if lhs.proximityUUID.isEqual(rhs.proximityUUID) {
            return true
        }
        return false
    }

    func isEqual(to rhs: FermentationDataProviderDevice) -> Bool {
        guard let rhs = rhs as? TiltBeacon else { return false }
        return self == rhs
    }
}
