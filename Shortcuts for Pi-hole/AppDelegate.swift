//
//  AppDelegate.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 12.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa
import Preferences

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let preferencesWindowController = PreferencesWindowController(viewControllers: [GeneralPreferenceViewController()])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        preferencesWindowController.showWindow()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        window.orderOut(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func preferencesMenuItemActionHandler(_ sender: Any) {
        preferencesWindowController.showWindow()
    }
}

