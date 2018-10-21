//
//  ColoredStatusView.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class ColoredStatusView: NSView {
    var fillingColor: NSColor = NSColor.red

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let fillColor = self.fillingColor
        let path = NSBezierPath(ovalIn: dirtyRect)
        fillColor.setFill()
        path.fill()
    }

    public func updateFillingColor(color: NSColor) {
        self.fillingColor = color
        self.display()
    }
}
