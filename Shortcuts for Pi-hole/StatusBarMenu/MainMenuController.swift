//
//  StatusBarMenuController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 20.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class MainMenuController: NSObject, NSMenuDelegate {
    
    @IBOutlet weak var statusBarMenu: NSMenu!
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBOutlet weak var statusMenuItem: NSMenuItem!
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    @IBOutlet weak var quitMenuItem: NSMenuItem!
    
    let mainWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController() as! MainWindowController
    let aboutWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AboutWindowControllerIdentifier") as! AboutWindowController

    override init() {
        super.init()
    }
    
    override func awakeFromNib() {
        if let statusBarButton = statusBarItem.button {
            statusBarButton.image = NSImage(named: "StatusBarButtonImage")
        }
        
        statusBarItem.menu = statusBarMenu
        statusBarMenu.delegate = self
        
        // refresh status on creation
        performPiHoleAction(action: PiHoleAction.Status)
    }
    
    @IBAction func refreshMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Status)
    }
    
    @IBAction func enablePermanentlyMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Enable)
    }
    
    @IBAction func disablePermanentlyMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Disable)
    }
    
    func performPiHoleAction(action: PiHoleAction) {
        if PiHoleProxy.getConfigStatus().isPositive() {
            self.dispatchStatusMenuItemUpdate(withTitle: "Pi-hole Status: Requesting...")
            
            PiHoleProxy.performActionRequest(PiHoleAction.Status, onSuccess: { (status) in
                self.dispatchStatusMenuItemUpdate(withTitle: "Pi-hole Status: " + status)
            }) { (error) in self.dispatchStatusMenuItemUpdate(withTitle: "Error: No connection.") }
        } else {
            self.dispatchStatusMenuItemUpdate(withTitle: "Error: Configuration invalid.")
        }
    }
    
    func dispatchStatusMenuItemUpdate(withTitle: String) {
        DispatchQueue.main.async {
            self.statusMenuItem.title = withTitle
        }
    }
    
    @IBAction func aboutMenuItemActionHandler(_ sender: NSMenuItem) {
        //NSApplication.shared.orderFrontStandardAboutPanel()
        aboutWindowController.showWindow(self)
    }
    
    @IBAction func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        mainWindowController.showWindow(self)
    }
    
    @IBAction func quitMenuItemActionHandler(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
