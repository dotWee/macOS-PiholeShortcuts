//
//  MainAboutViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class ConnectionPreferencesViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.
        _ = self.displayBuiltUrl()
    }

    @IBOutlet weak var coloredStatusViewOutlet: ColoredStatusView!

    @IBOutlet weak var connectionStatusTextField: NSTextField!
    
    @IBOutlet weak var statusValueTextField: NSTextField!
    
    @IBOutlet var apiResponseTextView: NSTextView!
    
    private func displayStatus(status: String, color: NSColor, apiResponse: String? = nil) {
        self.connectionStatusTextField.stringValue = status
        self.coloredStatusViewOutlet.updateFillingColor(color: color)
        
        if (apiResponse != nil) {
            self.apiResponseTextView.string = apiResponse!
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
            self.displayStatus(status: "Press update to verify", color: PiHoleConnectionResult.colorResultNeutral)
            return true;
        } else {
            self.displayStatus(status: connectionStatus.message, color: connectionStatus.color)
            
            // show invalid config alert
            self.displayConfigurationErrorAlert()
            return false;
        }
    }

    @IBAction func updateButtonActionHandler(_ sender: Any) {

        if self.displayBuiltUrl() {
            displayStatus(status: "Requesting...", color: PiHoleConnectionResult.colorResultNeutral)
            
            PiHoleProxy.performActionRequest(PiHoleAction.Status, onSuccess: { (status, responseObj) in
                DispatchQueue.main.async {
                    self.statusValueTextField.stringValue = status.firstCapitalized
                    
                    if let jsonResponseData = try?  JSONSerialization.data(
                        withJSONObject: responseObj,
                        options: .prettyPrinted
                        ),
                        let jsonResponseString = String(data: jsonResponseData, encoding: String.Encoding.ascii) {
                        self.displayStatus(status: "Connection established", color: PiHoleConnectionResult.colorResultPositive, apiResponse: jsonResponseString)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.displayStatus(status: "An error occurred", color: PiHoleConnectionResult.colorResultNegative, apiResponse: error.domain)
                }
            }
        }
    }
}

extension String {
    var firstCapitalized: String {
        var components = self.components(separatedBy: " ")
        guard let first = components.first else {
            return self
        }
        components[0] = first.capitalized
        return components.joined(separator: " ")
    }
}
