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
    
    override var nibName: NSNib.Name? {
        return "GeneralPreferenceViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stuff here
    }
}
