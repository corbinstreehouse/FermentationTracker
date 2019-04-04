//
//  Beacon.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/3/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import CoreBluetooth


class Beacon {
    let proximityUUID: CBUUID
    let majorValue: UInt16
    let minorValue: UInt16
    let transmitPower: Int8
    var rssi: UInt16 = 0
    
    convenience init?(withAdvertisementData advertisementData: [String: Any]?) {
        let kCBAdvDataManufacturerData = "kCBAdvDataManufacturerData"
        guard let advertisementData = advertisementData else { return nil }
        guard let manufacturerData = advertisementData[kCBAdvDataManufacturerData] as? Data else { return nil }
        self.init(withManufacturerData: manufacturerData)
    }
    
    // returns nil if we couldn't parse the data to find an iBeacon
    convenience init?(withManufacturerData manufacturerData: Data?) {
        guard let data = manufacturerData else { return nil }
        // Follow the iBeacon spec.
        // https://en.wikipedia.org/wiki/IBeacon
        if data.count != 25 { return nil}
        if data[0] != 0x4C || data[1] != 0x00 { return nil } // Apple identifier
        if data[2] != 0x02 { return nil } // iBeacon subtype identifier
        if data[3] != 0x15 { return nil } // Subtype length (fixed)
        // UUID for this iBeacon; length:
        let uuidData = data.subdata(in: 4..<(4 + 16))
        let proximityUUID = CBUUID(data: uuidData)
        // Major/minor/signal power
        let majorValue = data.to(type: UInt16.self, in: 20..<22).bigEndian // specific to tilt...littleEndian might be normal for these...
        let minorValue = data.to(type: UInt16.self, in: 22..<24).bigEndian
        let transmitPower = data.to(type: Int8.self, in: 24..<25)
        self.init(withProximityUUID: proximityUUID, majorValue: majorValue, minorValue: minorValue, transmitPower: transmitPower)
    }
    
    // Subclass may return nil for specific types
    init?(withProximityUUID proximityUUID: CBUUID, majorValue: UInt16, minorValue: UInt16, transmitPower: Int8) {
        self.proximityUUID = proximityUUID
        self.majorValue = majorValue
        self.minorValue = minorValue
        self.transmitPower = transmitPower
    }
}
