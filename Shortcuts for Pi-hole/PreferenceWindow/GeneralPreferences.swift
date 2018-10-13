//
//  GeneralPreferences.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

struct GeneralPreferences {
    static let (hostAddressKey, hostPortKey, requestProtocolKey, apiKey) = ("HOST_ADDRESS", "HOST_PORT", "REQUEST_PROTOCOL", "API_KEY")
    static let userSessionKey = Bundle.main.bundleIdentifier!
    
    struct Model {
        var hostAddress: String?
        var hostPort: String?
        var requestProtocol: String?
        var apiKey: String?
        
        init(_ json: [String: String]) {
            self.hostAddress = json[GeneralPreferences.hostAddressKey]
            self.hostPort = json[GeneralPreferences.hostPortKey]
            self.requestProtocol = json[GeneralPreferences.requestProtocolKey]
            self.apiKey = json[GeneralPreferences.apiKey]
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
        let hostPort = getHostPort()
        return Int(hostPort) != nil
    }
    
    static func getHostAddress() -> String? {
        return UserDefaults.standard.string(forKey: GeneralPreferences.hostAddressKey)
    }
    
    static func getHostPort() -> String {
        if let hostPort = UserDefaults.standard.string(forKey: GeneralPreferences.hostPortKey), !hostPort.isEmpty {
            // it's not nil nor an empty string
            return hostPort
        }
        
        return "80"
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
    
    static func saveHostAddress(hostAddress: String) {
        UserDefaults.standard.set(hostAddress, forKey: GeneralPreferences.hostAddressKey)
    }
    
    static func saveHostPort(hostPort: String) {
        UserDefaults.standard.set(hostPort, forKey: GeneralPreferences.hostPortKey)
    }
    
    static func saveRequestProtocol(requestProtocol: String) {
        UserDefaults.standard.set(requestProtocol, forKey: GeneralPreferences.requestProtocolKey)
    }
    
    static func saveApiKey(apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: GeneralPreferences.apiKey)
    }
    
    static var savePreferences = { (hostAddress: String, hostPort: String, requestProtocol: String, apiKey: String) in UserDefaults.standard.set([GeneralPreferences.hostAddressKey: hostAddress, GeneralPreferences.hostPortKey: hostPort, GeneralPreferences.requestProtocolKey: requestProtocol, GeneralPreferences.apiKey: apiKey], forKey: GeneralPreferences.userSessionKey)
    }
    
    static var getPreferences = { _ -> Model in
        return Model((UserDefaults.standard.value(forKey: GeneralPreferences.userSessionKey) as? [String: String]) ?? [:])
    }(())
    
    static func clearPreferences(){
        UserDefaults.standard.removeObject(forKey: GeneralPreferences.userSessionKey)
    }
}
