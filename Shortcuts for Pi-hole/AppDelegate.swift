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
    
    static let menuItems = [AppDelegate.menuItemEnable, AppDelegate.menuItemDisable, AppKit.NSMenuItem.separator(), AppDelegate.menuItemPreferences, AppKit.NSMenuItem.separator(), AppDelegate.menuItemQuit]
    
    static let menuItemEnable = NSMenuItem(title: "Enable", action: #selector(AppDelegate.menuItemEnableActionHandler(_:)), keyEquivalent: "E", isEnabled: true)
    @objc func menuItemEnableActionHandler(_ sender: Any?) {
        PiHoleProxy.performActionRequest(PiHoleAction.Enable, onSuccess: { (status) in
            print("menuItemEnableActionHandler: STATUS " + status)
        }) { (error) in
            print("menuItemEnableActionHandler: ERROR " + (error?.localizedDescription)!)
        }
    }
    
    static let menuItemDisable = NSMenuItem(title: "Disable", action: #selector(AppDelegate.menuItemDisableActionHandler(_:)), keyEquivalent: "D", isEnabled: true)
    @objc func menuItemDisableActionHandler(_ sender: Any?) {
        PiHoleProxy.performActionRequest(PiHoleAction.Disable, onSuccess: { (status) in
            print("menuItemDisableActionHandler: STATUS " + status)
        }) { (error) in
            print("menuItemDisableActionHandler: ERROR " + (error?.localizedDescription)!)
        }
    }
    
    static let menuItemPreferences = NSMenuItem(title: "Preferences", action: #selector(AppDelegate.menuItemPreferenceActionHandler(_:)), keyEquivalent: "P", isEnabled: true)
    @objc func menuItemPreferenceActionHandler(_ sender: Any?) {
        preferencesWindowController.showWindow()
    }
    
    static let menuItemQuit = NSMenuItem(title: "Quit " + (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q", isEnabled: true)

    @IBOutlet weak var window: NSWindow!
    
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    @objc func statusBarItemActionHandler(_ sender: NSStatusBarButton) {
        
    }
    
    let preferencesWindowController = PreferencesWindowController(viewControllers: [GeneralPreferenceViewController()])

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        preferencesWindowController.showWindow()
        if let button = statusBarItem.button {
            button.image = NSImage(named:"StatusBarButtonImage")
            button.action = #selector(self.statusBarItemActionHandler(_:))
            button.target = self
        }
        
        let menu = NSMenu()

        AppDelegate.menuItems.forEach { menuItem in menu.addItem(menuItem) }
        statusBarItem.menu = menu
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        window.orderOut(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        preferencesWindowController.close()
    }

    @IBAction func preferencesMenuItemActionHandler(_ sender: Any) {
        preferencesWindowController.showWindow()
    }
    
    static func NSMenuItem(title: String, action selector: Selector?, keyEquivalent charCode: String, isEnabled: Bool) -> NSMenuItem {
        let menuItem = AppKit.NSMenuItem(title: title, action: selector, keyEquivalent: charCode)
        menuItem.isEnabled = isEnabled
        return menuItem
    }
}

