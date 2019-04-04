//
//  TiltBluetoothScanner.swift
//  FermentationTracker
//
//  Created by Corbin Dunn on 4/3/19.
//  Copyright © 2019 Corbin Dunn. All rights reserved.
//

import Foundation
import CoreBluetooth

// Example find:
// found:<CBPeripheral: 0x600000107230, identifier = BF1C65E5-0399-496E-9663-7F9FC6C20CD1, name = (null), state = disconnected> data:["kCBAdvDataIsConnectable": 0, "kCBAdvDataAppleMfgData": {
//        kCBScanOptionAppleFilterPuckType = 2;
//    }, "kCBAdvDataManufacturerData": <4c000215 a495bb30 c5b14b44 b5121370 f02d74de 00430400 05>] rssi: -98


class TiltBluetoothScanner: NSObject, CBCentralManagerDelegate {
    
    lazy var centralManager: CBCentralManager = CBCentralManager(delegate: self, queue: nil)

    // UI bindings
    @objc dynamic var managerStateDescription: String = ""
    
    func startScanning() {
        checkBluetoothState()
    }
    
    private func scanForPeripherals() {
        // Do nil to find everything in range
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    // CBCentralManagerDelegate delegate methods
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        checkBluetoothState();

    }
    
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//
//    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let tiltBeacon = TiltBeacon(withAdvertisementData: advertisementData) {
            tiltBeacon.rssi = RSSI.uint16Value
            print("found TILT:\(tiltBeacon.proximityUUID) major: \(tiltBeacon.majorValue) minor: \(tiltBeacon.minorValue) transmitPower: \(tiltBeacon.transmitPower) color: \(tiltBeacon.color)")
        }
    }

    // End CBCentralManagerDelegate delegate methods.
    
    func checkBluetoothState() {
        let state = centralManager.state;
        
        switch (state) {
        case .unsupported:
            managerStateDescription = "Bluetooth LE is not supported by this machine"
        case .poweredOff:
            managerStateDescription = "Bluetooth LE is not powered on"
        case .resetting:
            managerStateDescription = "Bluetooth LE is resetting"
        case .unauthorized:
            managerStateDescription = "This application is not authorized to use Bluetooth LE"
        case .unknown:
            managerStateDescription = "Bluetooth LE in an unknown state"
        case .poweredOn:
            managerStateDescription = ""
        }
        let poweredOn = state == .poweredOn
        if poweredOn {
            scanForPeripherals()
        }
        
    }
    
}
