//
//  Preferences.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

struct Preferences {
    static let (hostAddressKey, hostPortKey, requestProtocolKey, apiKey, timeoutKey) = ("HOST_ADDRESS", "HOST_PORT", "REQUEST_PROTOCOL", "API_KEY", "REQUEST_TIMEOUT")
    static let userSessionKey = Bundle.main.bundleIdentifier!
    
    static let DEFAULT_TIMEOUT = 1

    struct Model {
        var hostAddress: String?
        var hostPort: String?
        var requestProtocol: String?
        var apiKey: String?
        var timeout: String?

        init(_ json: [String: String]) {
            self.hostAddress = json[Preferences.hostAddressKey]
            self.hostPort = json[Preferences.hostPortKey]
            self.requestProtocol = json[Preferences.requestProtocolKey]
            self.apiKey = json[Preferences.apiKey]
            self.timeout = json[Preferences.timeoutKey]
        }
    }

    static func isHostAddressValid() -> Bool {
        if let hostAddress = UserDefaults.standard.string(forKey: Preferences.hostAddressKey), !hostAddress.isEmpty {
            // it's not nil nor an empty string
            return true
        } else {
            return false
        }
    }

    static func isRequestProtocolValid() -> Bool {
        let requestProtocol = getRequestProtocol()
        return requestProtocol == "http" || requestProtocol == "https"
    }

    static func isApiKeyValid() -> Bool {
        if let apiKey = UserDefaults.standard.string(forKey: Preferences.apiKey), !apiKey.isEmpty {
            // it's not nil nor an empty string
            return true
        } else {
            return false
        }
    }

    static func isHostPortValid() -> Bool {
        return getHostPort() > 0
    }

    static func isTimeoutValid() -> Bool {
        return getTimeout() > 0
    }

    static func getHostAddress() -> String? {
        return UserDefaults.standard.string(forKey: Preferences.hostAddressKey)
    }

    static func getHostPort() -> Int {
        let hostPort = UserDefaults.standard.integer(forKey: Preferences.hostPortKey)
        return (hostPort == 0) ? 80 : hostPort
    }

    static func getRequestProtocol() -> String {
        if let requestProtocol = UserDefaults.standard.string(forKey: Preferences.requestProtocolKey), !requestProtocol.isEmpty {
            // it's not nil nor an empty string
            return requestProtocol
        }

        return "http"
    }

    static func getApiKey() -> String {
        return UserDefaults.standard.string(forKey: Preferences.apiKey) ?? ""
    }

    static func getTimeout() -> Int {
        let timeout = UserDefaults.standard.integer(forKey: Preferences.timeoutKey)
        return timeout <= 0 ? DEFAULT_TIMEOUT : timeout
    }

    static func saveHostAddress(hostAddress: String) {
        UserDefaults.standard.set(hostAddress, forKey: Preferences.hostAddressKey)
    }

    static func saveHostPort(hostPort: Int) {
        UserDefaults.standard.set(hostPort, forKey: Preferences.hostPortKey)
    }

    static func saveRequestProtocol(requestProtocol: String) {
        UserDefaults.standard.set(requestProtocol, forKey: Preferences.requestProtocolKey)
    }

    static func saveApiKey(apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: Preferences.apiKey)
    }

    static func saveTimeout(timeout: Int) {
        UserDefaults.standard.set(timeout, forKey: Preferences.timeoutKey)
    }

    static var savePreferences = { (hostAddress: String, hostPort: String, requestProtocol: String, apiKey: String, timeout: Int) in UserDefaults.standard.set([Preferences.hostAddressKey: hostAddress, Preferences.hostPortKey: hostPort, Preferences.requestProtocolKey: requestProtocol, Preferences.apiKey: apiKey, Preferences.timeoutKey: timeout], forKey: Preferences.userSessionKey)
    }

    static var getPreferences = { _ -> Model in
        return Model((UserDefaults.standard.value(forKey: Preferences.userSessionKey) as? [String: String]) ?? [:])
    }(())

    static func clearPreferences() {
        UserDefaults.standard.removeObject(forKey: Preferences.userSessionKey)
    }
}
