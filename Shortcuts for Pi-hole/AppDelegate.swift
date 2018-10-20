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

    static let menuItems = [AppDelegate.menuItemAbout, AppDelegate.menuItemPreferences, AppKit.NSMenuItem.separator(), AppDelegate.menuItemEnable, AppDelegate.menuItemDisable, AppKit.NSMenuItem.separator(), AppDelegate.menuItemQuit]

    static let menuItemAbout = NSMenuItem(title: "About", action: #selector(AppDelegate.menuItemAboutActionHandler(_:)), keyEquivalent: "A", isEnabled: true)
    @objc func menuItemAboutActionHandler(_ sender: Any?) {

    }

    static let menuItemPreferences = NSMenuItem(title: "Preferences...", action: #selector(AppDelegate.menuItemPreferenceActionHandler(_:)), keyEquivalent: "P", isEnabled: true)
    @objc func menuItemPreferenceActionHandler(_ sender: Any?) {
        mainWindowController.showWindow(self)
    }

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

    static let menuItemQuit = NSMenuItem(title: "Quit " + (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q", isEnabled: true)

    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    @objc func statusBarItemActionHandler(_ sender: NSStatusBarButton) {

    }

    let mainWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController() as! MainWindowController

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        mainWindowController.showWindow(self)

        if let button = statusBarItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(self.statusBarItemActionHandler(_:))
            button.target = self
        }

        let menu = NSMenu()

        AppDelegate.menuItems.forEach { menuItem in menu.addItem(menuItem) }
        statusBarItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        mainWindowController.close()
    }

    @IBAction func preferencesMenuItemActionHandler(_ sender: Any) {
        mainWindowController.showWindow(self)
    }

    static func NSMenuItem(title: String, action selector: Selector?, keyEquivalent charCode: String, isEnabled: Bool) -> NSMenuItem {
        let menuItem = AppKit.NSMenuItem(title: title, action: selector, keyEquivalent: charCode)
        menuItem.isEnabled = isEnabled
        return menuItem
    }
}

