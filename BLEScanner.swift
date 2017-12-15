//
//  BLEScanner.swift
//  nRF_BLE_UART_Sample
//
//  Created by Sky Krishna on 16/12/17.
//  Copyright © 2017 CellTec. All rights reserved.
//

import Foundation
import CoreBluetooth

let BLESharedInstance = BTScanner();

class BTScanner: NSObject, CBCentralManagerDelegate {
    
    fileprivate var centralManager: CBCentralManager?
    fileprivate var connectedPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    //Start the Bluetooth scanner
    func startScanning() {
        if let central = centralManager {
            central.scanForPeripherals(withServices: [BLEServiceUUID], options: nil)
        }
    }
    
    //Lets call the discovery function in BLEManager class
    var bleService: BLEManager? {
        didSet {
            if let service = self.bleService {
                service.startDiscoveringServices()
            }
        }
    }
    
    
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
       
        if ((peripheral.name == nil) || (peripheral.name == "")) {
            return
        }
        
        if ((self.connectedPeripheral == nil) || (self.connectedPeripheral?.state == CBPeripheralState.disconnected)) {
           
            self.connectedPeripheral = peripheral
          
            self.connectedPeripheral = nil
         
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        // Create new service class
            if (peripheral == self.connectedPeripheral) {
            self.bleService = BLEManager(initWithPeripheral: peripheral)
        }
        
        // Stop scanning for new devices
        //This is important or else it keeps scanning but never gets properly connected
            central.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // Disconnect block
            if (peripheral == self.connectedPeripheral) {
            self.connectedPeripheral = nil;
        }
        
        // Start scanning for new devices again as peripheral is disconnected
            self.startScanning()
    }
  
    
  
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            self.clearDevices()
            
        case .unauthorized:
            break
            
        case .unknown:
            break
            
        case .poweredOn:
            self.startScanning()
            
        case .resetting:
            self.clearDevices()
            
        case .unsupported:
            break
        }
        
    }
    
    //This is called to reset the service and perpheral when the BLE central is power off state or reset state
    func clearDevices() {
        self.bleService = nil
        self.connectedPeripheral = nil
    }
    
    
}
