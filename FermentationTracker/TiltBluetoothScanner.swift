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
    #if DEBUG
    var t: DispatchSourceTimer!
    
    static func random(in range:Range<Int>) -> Int
    {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    private func testAddAllTilts() {
        for tiltColor in TiltColor.allCases {
            let temperature: Double = Double(TiltBluetoothScanner.random(in: 50..<110))
            let fakeTilt = TiltBeacon(withColor: tiltColor, temperature: temperature, signficantGravity: 1.055, transmitPower:-50)
            self.notifyFoundTiltHandlersFor(tilt: fakeTilt)
        }
    }
    
    private func addFakeUpdates() {
        var startingGravity = 1.170
        
        // add fake data after a delay
        t = DispatchSource.makeTimerSource()
        t.schedule(deadline: DispatchTime.now(), repeating: 5)
        t.setEventHandler(handler: {
            print("Adding a FAKE TILT for testing!")
            startingGravity -= 0.001
            let temperature: Double = Double(TiltBluetoothScanner.random(in: 50..<110))
            let fakeTilt = TiltBeacon(withColor: TiltColor.black, temperature: temperature, signficantGravity: startingGravity, transmitPower:-50)
            self.notifyFoundTiltHandlersFor(tilt: fakeTilt)
        })
        t.resume()
    }
    #endif

    // Well, really starts scanning when bluetooth is on.
    func startScanning() {
        checkBluetoothState()
//        testAddAllTilts()
//        addFakeUpdates()
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
        // This may get called on a background thread and be racy
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.checkBluetoothState();
            }
        } else {
            checkBluetoothState();
        }
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
