//
//  AboutWindowController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 21.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    @IBOutlet weak var aboutWindow: NSWindow!
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        
        AppDelegate.bringToFront(window: self.window!)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}
