//
//  AboutViewController.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 21.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("AboutViewController: viewDidLoad()")
       
        loadDescription()
    }
    
    @IBOutlet weak var descriptionTextField: NSTextField!
    
    private func loadDescription() {
        
    }

}
