//
//  BLEManager.swift
//  nRF_BLE_UART_Sample
//
//  Created by nar on 16/12/17.
//  Copyright © 2017 csu. All rights reserved.
//

import Foundation
import CoreBluetooth

//Now declaring the Service identifiers
let BLEServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
let BLE_TX_char = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
let BLE_RX_char = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")


//Now simple ble service class

class BLEManager: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var txcharacterstic: CBCharacteristic?
    var rxcharacterstic: CBCharacteristic?
    
    init(initWithPeripheral peripheral:CBPeripheral){
        super.init()
        //initialising the peripheral delegate methods
        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }
    
    deinit{
        //lets create a function to dsconnect the peripheral and de-initialise the device from the app
        self.reset()
    }
    
    //Lets assume the peripheral is made nil if reset is called
    func reset(){
        //Check if peripheral is nil if yes then make it nil
        if peripheral != nil{
            peripheral = nil
        }
        }
    
    
    //Lets start discovery
    func startDiscoveringServices(){
        self.peripheral?.discoverServices([BLEServiceUUID])
    }
    
    
    //Now peripheral delegate
    
    func peripheral(_peripheral: CBPeripheral, didDiscoverServices error:Error?){
    
        if (peripheral != self.peripheral){
            return
        }
        if (error != nil){
            return
        }
        if ((peripheral?.services == nil) || (peripheral?.services!.count == 0)) {
            //If no services are found then incorrect device is selected
            return
        }
        
        for service in (peripheral?.services)!{
            let serviceUUID: [CBUUID] = [BLE_TX_char]
            if service.uuid == BLEServiceUUID{
                peripheral?.discoverCharacteristics(serviceUUID, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if(peripheral != self.peripheral){
            return
        }
        
        if (error != nil){
            return
        }
        
        //Discovering characterstics for the subscribed service
        if let characterstics = service.characteristics{
            for characterstic in characterstics {
                if characterstic.uuid == BLE_TX_char {
                    self.txcharacterstic = (characterstic)
                    peripheral.setNotifyValue(true, for: characterstic)
                }
            }
        }
}


