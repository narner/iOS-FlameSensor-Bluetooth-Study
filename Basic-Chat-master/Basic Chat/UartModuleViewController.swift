//
//  UartModuleViewController.swift
//  Basic Chat
//


import UIKit
import CoreBluetooth

class UartModuleViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
  
    //UI
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var backgroundView: UIView!
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        peripheralManager?.stopAdvertising()
        self.peripheralManager = nil
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateIncomingData () {
     NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
     notification in
        
            let dataString = characteristicASCIIValue as String
            if (dataString == "0"){
                self.stateLabel.text = "Close Fire"
                self.backgroundView.backgroundColor = UIColor.red
            } else if (dataString == "1") {
                self.stateLabel.text = "Distant Fire"
                self.backgroundView.backgroundColor = UIColor.red
            } else {
                self.stateLabel.text = "No Fire"
                self.backgroundView.backgroundColor = UIColor.white
            }
        }
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }

    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }
}
