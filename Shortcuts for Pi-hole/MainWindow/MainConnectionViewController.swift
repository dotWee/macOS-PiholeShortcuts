//
//  MainAboutViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class MainConnectionViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.
        _ = self.displayBuiltUrl()
    }

    @IBOutlet weak var coloredStatusViewOutlet: ColoredStatusView!

    @IBOutlet weak var connectionStatusTextField: NSTextField!

    @IBOutlet weak var urlTextField: NSTextField!
    
    @IBOutlet var connectionLogTextView: NSTextView!
    
    private func displayStatus(status: String, color: NSColor, log: String? = nil) {
        self.connectionStatusTextField.stringValue = status
        self.coloredStatusViewOutlet.updateFillingColor(color: color)
        
        if (log != nil) {
            self.connectionLogTextView.string = log!
        }
    }
    
    private func displayConfigurationErrorAlert() {
        let alert = NSAlert()
        alert.messageText = "Invalid configuration"
        alert.informativeText = "Please check your configuration."
        alert.addButton(withTitle: "Ok")
        
        if let mainWindow = self.view.window {
            alert.beginSheetModal(for: mainWindow) { (returnCode: NSApplication.ModalResponse) -> Void in
                print ("returnCode: ", returnCode)
            }
        }
    }
    
    private func displayBuiltUrl() -> Bool {
        let connectionStatus = PiHoleProxy.getConfigStatus()
        
        if connectionStatus.isPositive() {
            
            // display url
            let url = PiHoleProxy.getBaseUrl(action: PiHoleAction.Enable)
            urlTextField.stringValue = url!.absoluteString
            
            self.displayStatus(status: "Press connect to verify", color: PiHoleConnectionResult.colorResultNeutral)
            return true;
        } else {
            self.displayStatus(status: connectionStatus.message, color: connectionStatus.color)
            
            // show invalid config alert
            self.displayConfigurationErrorAlert()
            return false;
        }
    }

    @IBAction func connectionButtonActionHandler(_ sender: Any) {

        if self.displayBuiltUrl() {
            displayStatus(status: "Requesting...", color: PiHoleConnectionResult.colorResultNeutral)
            
            PiHoleProxy.performActionRequest(PiHoleAction.Status, onSuccess: { (status) in
                DispatchQueue.main.async {
                    self.displayStatus(status: "Connection established", color: PiHoleConnectionResult.colorResultPositive, log: "Current Pi-hole status: \(status)")
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.displayStatus(status: "An error occurred", color: PiHoleConnectionResult.colorResultNegative, log: error.domain)
                }
            }
        }
    }
}
