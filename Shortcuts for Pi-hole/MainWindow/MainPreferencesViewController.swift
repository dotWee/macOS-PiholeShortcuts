//
//  GeneralPreferenceViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 12.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

final class MainPreferencesViewController: NSViewController {
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
        GeneralPreferences.saveHostAddress(hostAddress: hostAddress)

        self.onPreferencesChange()
    }


    @IBAction func connectButtonActionHandler(_ sender: NSButton) {
        self.onConnectionStatusChange(status: ConnectionStatus(message: "Requesting...", color: NSColor.gray))

        guard let url = PiHoleProxy.getBaseUrl() else {
            onConnectionStatusChange(status: ConnectionStatus(message: "Error constructing endpoint", color: NSColor.red))
            return;
        }

        let task = PiHoleProxy.getDefaultURLSession().dataTask(with: url) { (data, response, error) in
            print("dataTask on " + url.absoluteString)

            let connectionStatus: ConnectionStatus;
            if (error != nil) {
                connectionStatus = ConnectionStatus(message: error!.localizedDescription, color: NSColor.red)
            } else if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("status code " + String(describing: statusCode) + " on host " + (url.absoluteString))

                connectionStatus = ConnectionStatus(
                    message: (statusCode == 200) ? "Connection established" : "Host returned invalid response",
                    color: (statusCode == 200) ? NSColor.green : NSColor.red)
            } else {
                connectionStatus = ConnectionStatus(message: "Host returned invalid response", color: NSColor.red)
            }

            DispatchQueue.main.async {
                print(connectionStatus.message)
                self.onConnectionStatusChange(status: connectionStatus)
            }
        }
        task.resume()
    }

    @IBAction func hostPortActionHandler(_ sender: NSTextField) {
        let hostPort = sender.integerValue
        print("hostPortActionHandler", hostPort)
        GeneralPreferences.saveHostPort(hostPort: hostPort)

        self.onPreferencesChange()
    }

    @IBAction func requestProtocolActionHandler(_ sender: NSPopUpButton) {
        let requestProtocol = sender.titleOfSelectedItem!
        print("requestProtocolActionHandler", requestProtocol)
        GeneralPreferences.saveRequestProtocol(requestProtocol: requestProtocol)

        self.onPreferencesChange()
    }
    @IBAction func apiKeyActionHandler(_ sender: NSSecureTextField) {
        let apiKey = sender.stringValue
        print("apiKeyActionHandler", apiKey)
        GeneralPreferences.saveApiKey(apiKey: apiKey)

        self.onPreferencesChange()
    }
    @IBAction func timeoutActionHandler(_ sender: NSTextField) {
        let timeout = sender.integerValue
        print("timeoutActionHandler", timeout)
        GeneralPreferences.saveTimeout(timeout: timeout)

        self.onPreferencesChange()
    }

    func onConnectionStatusChange(status: ConnectionStatus) {
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
        if let hostAddress = GeneralPreferences.getHostAddress(), !hostAddress.isEmpty {
            textFieldHostAddress.stringValue = hostAddress
        }

        let hostPort = GeneralPreferences.getHostPort()
        textFieldHostPort.integerValue = hostPort

        let requestProtocol = GeneralPreferences.getRequestProtocol()
        popUpButtonRequestProtocol.selectItem(withTitle: requestProtocol)

        let apiKey = GeneralPreferences.getApiKey()
        if !apiKey.isEmpty {
            secureTextFieldApiKey.stringValue = apiKey
        }

        // check status
        self.onPreferencesChange()
    }
}
