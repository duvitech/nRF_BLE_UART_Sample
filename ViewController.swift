//
//  ViewController.swift
//  nRF_BLE_UART_Sample
//
//  Created by Sky Krishna on 16/12/17.
//  Copyright © 2017 CellTec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lets load the discovery func block from shared instance.
        // Do any additional setup after loading the view, typically from a nib.
        _ = BLESharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    
}

