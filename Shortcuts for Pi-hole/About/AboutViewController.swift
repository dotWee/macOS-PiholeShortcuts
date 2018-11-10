//
//  AboutViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 21.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    
    @IBOutlet weak var versionTextField: NSTextField!
    
    @IBAction func viewSourceCodeActionHandler(_ sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "https://github.com/dotWee/macOS-PiholeShortcuts")!)
    }
    
    @IBAction func visitPiHoleProjectActionHandler(_ sender: NSButton) {
        NSWorkspace.shared.open(URL(string: "https://pi-hole.net")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        print("AboutViewController: viewDidLoad()")
        
        let versionValue = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let bundleValue = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        versionTextField.stringValue = "Version: \(versionValue!) (Bundle No. #\(bundleValue!))";
    }

}
