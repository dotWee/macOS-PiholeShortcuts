//
//  PiHoleConnectionResult.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 10.11.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class PiHoleConnectionResult: NSObject {

    let message: String
    let color: NSColor
    let error: NSError?
    
    init(message: String, color: NSColor, error: NSError? = nil) {
        self.message = message
        self.color = color
        self.error = error
    }
    
    public static func Positive(message: String) -> PiHoleConnectionResult {
        return PiHoleConnectionResult(message: message, color: colorResultPositive)
    }
    
    public static func Negative(message: String, error: NSError? = nil) -> PiHoleConnectionResult {
        return PiHoleConnectionResult(message: message, color: colorResultNegative, error: error)
    }
    
    public func isPositive() -> Bool {
        return self.color == PiHoleConnectionResult.colorResultPositive
    }
    
    static let lightRed = NSColor(red: 0.96, green: 0.05, blue: 0.10, alpha: 1.0)
    static let lightGreen = NSColor(red: 0.16, green: 0.99, blue: 0.18, alpha: 1.0)
    
    static let darkRed = NSColor(red: 0.59, green: 0.02, blue: 0.05, alpha: 1.0)
    static let darkGreen = NSColor(red: 0.13, green: 0.70, blue: 0.15, alpha: 1.0)
    
    static let colorResultPositive = lightGreen
    static let colorResultNegative = lightRed
    static let colorResultNeutral = NSColor.gray
}
