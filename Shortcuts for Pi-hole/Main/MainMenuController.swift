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
    
    let mainWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController() as! PreferencesWindowController
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
    
    @IBAction func enableFor30sMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Enable, seconds: 30)
    }
    
    @IBAction func enableFor1mMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Enable, seconds: 60)
    }
    
    @IBAction func enableFor1hMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Enable, seconds: 3600)
    }
    
    @IBAction func enablePermanentlyMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Enable)
    }
    
    @IBAction func disableFor30sMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Disable, seconds: 30)
    }
    
    @IBAction func disableFor1mMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Disable, seconds: 60)
    }
    
    @IBAction func disableFor1hMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Disable, seconds: 3600)
    }
    
    @IBAction func disablePermanentlyMenuItemActionHandler(_ sender: NSMenuItem) {
        performPiHoleAction(action: PiHoleAction.Disable)
    }
    
    func performPiHoleAction(action: PiHoleAction, seconds: Int = 0) {
        if PiHoleProxy.getConfigStatus().isPositive() {
            self.dispatchStatusMenuItemUpdate(withTitle: "Pi-hole: Requesting...")
            
            PiHoleProxy.performActionRequest(action, seconds: seconds, onSuccess: { status, responseDict  in
                self.dispatchStatusMenuItemUpdate(withTitle: "Pi-hole: " + status.firstCapitalized)
            }) { (error) in self.dispatchStatusMenuItemUpdate(withTitle: "Error: No connection.") }
        } else {
            self.dispatchStatusMenuItemUpdate(withTitle: "Error: Configuration invalid.")
        }
    }
    
    func dispatchStatusMenuItemUpdate(withTitle: String) {
        print("dispatchStatusMenuItemUpdate with title " + withTitle)
        DispatchQueue.main.async {
            self.statusMenuItem.title = withTitle
        }
    }
    
    @IBAction func aboutMenuItemActionHandler(_ sender: NSMenuItem) {
        aboutWindowController.showWindow(self)
    }
    
    @IBAction func dashboardMenuItemActionHandler(_ sender: NSMenuItem) {
        let url = PiHoleProxy.getDashboardUrl()
        NSWorkspace.shared.open(url!)
    }
    
    @IBAction func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        mainWindowController.showWindow(self)
    }
    
    @IBAction func quitMenuItemActionHandler(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
