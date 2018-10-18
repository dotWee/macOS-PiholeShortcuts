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
    }
    
    @IBAction func connectionButtonActionHandler(_ sender: Any) {
        let configStatus = PiHoleProxy.getConfigStatus()
        
        // config valid
        if configStatus.color == NSColor.green {
            // display url
            let url = PiHoleProxy.getBaseUrl(action: PiHoleAction.Status)
            exampleRequestUrlTextField.stringValue = url!.absoluteString
        } else {
            // show invalid config alert
            let alert = NSAlert()
            alert.messageText = "Invalid configuration"
            alert.informativeText = "Please check your configuration."
            alert.addButton(withTitle: "Ok")
            alert.beginSheetModal(for: self.view.window!) { (returnCode: NSApplication.ModalResponse) -> Void in
                print ("returnCode: ", returnCode)
            }
        }
    }
    
    
    @IBOutlet weak var exampleRequestUrlTextField: NSTextField!

    @IBOutlet var testConnectionTextView: NSTextView!
}
