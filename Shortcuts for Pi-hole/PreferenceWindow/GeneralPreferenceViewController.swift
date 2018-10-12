//
//  GeneralPreferenceViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 12.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa
import Preferences

final class GeneralPreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle: String = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    @IBAction func hostAddressActionHandler(_ sender: NSTextField) {
        let hostAddress = sender.stringValue
        print("hostAddressActionHandler", hostAddress)
        GeneralPreferences.saveHostAddress(hostAddress: hostAddress)
    }
    
    @IBAction func hostPortActionHandler(_ sender: NSTextField) {
        let hostPort = sender.stringValue
        print("hostPortActionHandler", hostPort)
        GeneralPreferences.saveHostPort(hostPort: hostPort)
    }
    
    @IBAction func requestProtocolActionHandler(_ sender: NSPopUpButton) {
        let requestProtocol = sender.titleOfSelectedItem!
        print("requestProtocolActionHandler", requestProtocol)
        GeneralPreferences.saveRequestProtocol(requestProtocol: requestProtocol)
    }
    @IBAction func apiKeyActionHandler(_ sender: NSSecureTextField) {
        let apiKey = sender.stringValue
        print("apiKeyActionHandler", apiKey)
        GeneralPreferences.saveApiKey(apiKey: apiKey)
    }
    
    override var nibName: NSNib.Name? {
        return "GeneralPreferenceViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
