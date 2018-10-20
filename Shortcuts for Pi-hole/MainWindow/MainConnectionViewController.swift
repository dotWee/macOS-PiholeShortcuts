//
//  MainAboutViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class MainConnectionViewController: NSViewController {
    var connectionStatus: ConnectionStatus?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.
        self.displayBuiltUrl()
    }

    @IBOutlet weak var coloredStatusViewOutlet: ColoredStatusView!

    @IBOutlet weak var statusMessageLabelOutlet: NSTextField!

    func displayBuiltUrl() {
        connectionStatus = PiHoleProxy.getConfigStatus()

        // config valid
        if connectionStatus!.color == NSColor.green {
            // display url
            let url = PiHoleProxy.getBaseUrl(action: PiHoleAction.Status)
            exampleRequestUrlTextField.stringValue = url!.absoluteString

            statusMessageLabelOutlet.stringValue = "Press connect to verify"
            coloredStatusViewOutlet.updateFillingColor(color: NSColor.gray)
        } else {
            statusMessageLabelOutlet.stringValue = "Invalid configuration"
            coloredStatusViewOutlet.updateFillingColor(color: NSColor.red)

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

    @IBAction func connectionButtonActionHandler(_ sender: Any) {
        self.displayBuiltUrl()

        if connectionStatus!.color == NSColor.green {
            statusMessageLabelOutlet.stringValue = "Requesting..."
            coloredStatusViewOutlet.updateFillingColor(color: NSColor.yellow)

            PiHoleProxy.performActionRequest(PiHoleAction.Status, onSuccess: { (status) in
                DispatchQueue.main.async {
                    self.testConnectionTextView.string = "Current Pi-hole status: " + status
                    self.statusMessageLabelOutlet.stringValue = "Connection established"
                    self.coloredStatusViewOutlet.updateFillingColor(color: NSColor.green)
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.testConnectionTextView.string = error.debugDescription
                    self.statusMessageLabelOutlet.stringValue = "An error occurred"
                    self.coloredStatusViewOutlet.updateFillingColor(color: NSColor.red)
                }
            }
        }
    }

    @IBOutlet weak var exampleRequestUrlTextField: NSTextField!

    @IBOutlet var testConnectionTextView: NSTextView!
}
