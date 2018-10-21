//
//  GeneralPreferences.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

struct GeneralPreferences {
    static let (hostAddressKey, hostPortKey, requestProtocolKey, apiKey, timeoutKey) = ("HOST_ADDRESS", "HOST_PORT", "REQUEST_PROTOCOL", "API_KEY", "REQUEST_TIMEOUT")
    static let userSessionKey = Bundle.main.bundleIdentifier!

    struct Model {
        var hostAddress: String?
        var hostPort: String?
        var requestProtocol: String?
        var apiKey: String?
        var timeout: String?

        init(_ json: [String: String]) {
            self.hostAddress = json[GeneralPreferences.hostAddressKey]
            self.hostPort = json[GeneralPreferences.hostPortKey]
            self.requestProtocol = json[GeneralPreferences.requestProtocolKey]
            self.apiKey = json[GeneralPreferences.apiKey]
            self.timeout = json[GeneralPreferences.timeoutKey]
        }
    }

    static func isHostAddressValid() -> Bool {
        if let hostAddress = UserDefaults.standard.string(forKey: GeneralPreferences.hostAddressKey), !hostAddress.isEmpty {
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
        if let apiKey = UserDefaults.standard.string(forKey: GeneralPreferences.apiKey), !apiKey.isEmpty {
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
        return UserDefaults.standard.string(forKey: GeneralPreferences.hostAddressKey)
    }

    static func getHostPort() -> Int {
        let hostPort = UserDefaults.standard.integer(forKey: GeneralPreferences.hostPortKey)
        return (hostPort == 0) ? 80 : hostPort
    }

    static func getRequestProtocol() -> String {
        if let requestProtocol = UserDefaults.standard.string(forKey: GeneralPreferences.requestProtocolKey), !requestProtocol.isEmpty {
            // it's not nil nor an empty string
            return requestProtocol
        }

        return "http"
    }

    static func getApiKey() -> String {
        return UserDefaults.standard.string(forKey: GeneralPreferences.apiKey) ?? ""
    }

    static func getTimeout() -> Int {
        return UserDefaults.standard.integer(forKey: GeneralPreferences.timeoutKey)
    }

    static func saveHostAddress(hostAddress: String) {
        UserDefaults.standard.set(hostAddress, forKey: GeneralPreferences.hostAddressKey)
    }

    static func saveHostPort(hostPort: Int) {
        UserDefaults.standard.set(hostPort, forKey: GeneralPreferences.hostPortKey)
    }

    static func saveRequestProtocol(requestProtocol: String) {
        UserDefaults.standard.set(requestProtocol, forKey: GeneralPreferences.requestProtocolKey)
    }

    static func saveApiKey(apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: GeneralPreferences.apiKey)
    }

    static func saveTimeout(timeout: Int) {
        UserDefaults.standard.set(timeout, forKey: GeneralPreferences.timeoutKey)
    }

    static var savePreferences = { (hostAddress: String, hostPort: String, requestProtocol: String, apiKey: String, timeout: Int) in UserDefaults.standard.set([GeneralPreferences.hostAddressKey: hostAddress, GeneralPreferences.hostPortKey: hostPort, GeneralPreferences.requestProtocolKey: requestProtocol, GeneralPreferences.apiKey: apiKey, GeneralPreferences.timeoutKey: timeout], forKey: GeneralPreferences.userSessionKey)
    }

    static var getPreferences = { _ -> Model in
        return Model((UserDefaults.standard.value(forKey: GeneralPreferences.userSessionKey) as? [String: String]) ?? [:])
    }(())

    static func clearPreferences() {
        UserDefaults.standard.removeObject(forKey: GeneralPreferences.userSessionKey)
    }
}
