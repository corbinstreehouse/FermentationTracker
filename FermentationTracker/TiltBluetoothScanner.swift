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
    
    private var centralManager: CBCentralManager!

    // UI bindings
    @objc dynamic var managerStateDescription: String = ""
    
    override init() {
        super.init()
        let bluetoothScannerQueue: DispatchQueue = DispatchQueue(label: "com.redwoodmonkey.FermentationTracker.TiltBluetooth")
        centralManager = CBCentralManager(delegate: self, queue: bluetoothScannerQueue)
    }
    
    deinit {
        stopScanning()
    }
    
    private var foundTiltHandlers: [(_ tiltBeacon: TiltBeacon) -> Void] = []
    // todo: remove method, if needed..
    func addFoundTiltHandler(_ handler: @escaping (_ tiltBeacon: TiltBeacon) -> Void) {
        foundTiltHandlers.append(handler)
    }
    
    private func notifyFoundTiltHandlersFor(tilt: TiltBeacon) {
        for handler in foundTiltHandlers {
            handler(tilt)
        }
    }
    
    // Well, really starts scanning when bluetooth is on.
    func startScanning() {
        checkBluetoothState()
        #if DEBUG
            // add fake data after a delay
            let queue = DispatchQueue.main
            queue.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1), execute: {
                print("Adding a FAKE TILT for testing!")
                let fakeTilt = TiltBeacon(withColor: TiltColor.black, temperature: 68, signficantGravity: 1.025, transmitPower:-50)
                self.notifyFoundTiltHandlersFor(tilt: fakeTilt)
            })
            
            
        #endif
    }
    
    func stopScanning() {
        if centralManager.isScanning {
            centralManager.stopScan()
        }
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
            tiltBeacon.rssi = RSSI.intValue
            notifyFoundTiltHandlersFor(tilt: tiltBeacon)
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
