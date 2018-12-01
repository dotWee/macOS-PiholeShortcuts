//
//  GeneralPreferenceViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 12.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

final class GeneralPreferencesViewController: NSViewController {
    @IBOutlet weak var secureTextFieldApiKey: NSSecureTextField!
    @IBOutlet weak var popUpButtonRequestProtocol: NSPopUpButton!

    @IBOutlet weak var textFieldHostPort: NSTextField!
    @IBOutlet weak var textFieldHostAddress: NSTextField!

    @IBOutlet weak var viewCircleConnectionStatus: ColoredStatusView!

    @IBOutlet weak var labelConnectionStatus: NSTextField!
    @IBOutlet weak var textFieldTimeout: NSTextField!

    @IBAction func hostAddressActionHandler(_ sender: NSTextField) {
        let hostAddress = sender.stringValue
        print("hostAddressActionHandler", hostAddress)
        Preferences.saveHostAddress(hostAddress: hostAddress)

        self.onPreferencesChange()
    }

    @IBAction func hostPortActionHandler(_ sender: NSTextField) {
        let hostPort = sender.integerValue
        print("hostPortActionHandler", hostPort)
        Preferences.saveHostPort(hostPort: hostPort)

        self.onPreferencesChange()
    }

    @IBAction func requestProtocolActionHandler(_ sender: NSPopUpButton) {
        let requestProtocol = sender.titleOfSelectedItem!
        print("requestProtocolActionHandler", requestProtocol)
        Preferences.saveRequestProtocol(requestProtocol: requestProtocol)

        self.onPreferencesChange()
    }
    @IBAction func apiKeyActionHandler(_ sender: NSSecureTextField) {
        let apiKey = sender.stringValue
        print("apiKeyActionHandler", apiKey)
        Preferences.saveApiKey(apiKey: apiKey)

        self.onPreferencesChange()
    }
    @IBAction func timeoutActionHandler(_ sender: NSTextField) {
        let timeout = sender.integerValue
        print("timeoutActionHandler", timeout)
        Preferences.saveTimeout(timeout: timeout)

        self.onPreferencesChange()
    }

    func onConnectionStatusChange(status: PiHoleConnectionResult) {
        self.viewCircleConnectionStatus.updateFillingColor(color: status.color)
        self.labelConnectionStatus.stringValue = status.message
    }

    func onPreferencesChange() {
        let connectionStatus = PiHoleProxy.getConfigStatus()
        self.onConnectionStatusChange(status: connectionStatus)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // restore persisted preferences in view
        if let hostAddress = Preferences.getHostAddress(), !hostAddress.isEmpty {
            textFieldHostAddress.stringValue = hostAddress
        }

        let hostPort = Preferences.getHostPort()
        textFieldHostPort.integerValue = hostPort

        let requestProtocol = Preferences.getRequestProtocol()
        popUpButtonRequestProtocol.selectItem(withTitle: requestProtocol)

        let apiKey = Preferences.getApiKey()
        if !apiKey.isEmpty {
            secureTextFieldApiKey.stringValue = apiKey
        }
        
        let timeout = Preferences.getTimeout()
        textFieldTimeout.integerValue = timeout

        // check status
        self.onPreferencesChange()
    }
}
