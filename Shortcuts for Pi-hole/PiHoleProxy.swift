//
//  PiHoleProxy.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

struct ConnectionStatus {
    let message: String
    let color: NSColor
    
    init(message: String, color: NSColor) {
        self.message = message
        self.color = color
    }
}

class PiHoleProxy: NSObject {
    
    public static func getBaseUrl() -> URL? {
        let hostAddress = GeneralPreferences.getHostAddress()
        let hostPort = GeneralPreferences.getHostPort()
        let requestProtocol = GeneralPreferences.getRequestProtocol()
        let apiKey = GeneralPreferences.getApiKey()
        
        let urlString = requestProtocol + "://" + hostAddress! + ":" + hostPort + "/admin/api.php?auth=" + apiKey
        return URL(string: urlString)
    }
    
    public static func getConfigStatus() -> ConnectionStatus {
        // check if host address is valid
        if (!GeneralPreferences.isHostAddressValid()) {
            return ConnectionStatus(message: "Invalid Host Address", color: NSColor.red)
        }
        
        // check if host port is valid
        if (!GeneralPreferences.isHostPortValid()) {
            return ConnectionStatus(message: "Invalid Host Port", color: NSColor.red)
        }
        
        // check if request protocol is valid
        if (!GeneralPreferences.isRequestProtocolValid()) {
            return ConnectionStatus(message: "Invalid Protocol", color: NSColor.red)
        }
        
        // check if api key is valid
        if (!GeneralPreferences.isApiKeyValid()) {
            return ConnectionStatus(message: "Invalid API Key", color: NSColor.red)
        }
        
        // define url on possible host
        if (getBaseUrl() == nil) {
            return ConnectionStatus(message: "Invalid URL", color: NSColor.yellow)
        }
        
        // config looks good!
        return ConnectionStatus(message: "Configuration is valid", color: NSColor.green)
    }
    
    public static func getDefaultURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        // timeout 2s
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        
        return URLSession(configuration: config)
    }
    
    public static func performPiRequest(_ endpoint: String, onSuccess success: @escaping (_ status: String) -> Void, onFailure failure: @escaping (_ error: Error?, _ endpoint: String) -> Void) {
        print("performPiRequest: endpoint=" + endpoint)
        
        do {
            guard let url = URL(string: endpoint) else {
                failure(NSError(domain: "Error invalid endpoint", code: 1, userInfo: nil), endpoint)
                return
            }
            
            let urlRequest = URLRequest(url: url)
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 5
            config.timeoutIntervalForResource = 5
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                
                // Check for any errors
                guard error == nil else {
                    failure(NSError(domain: "Error at executing request (timeout)", code: 2, userInfo: nil), endpoint)
                    return
                }
                
                // Make sure we got data
                guard let responseData = data else {
                    failure(NSError(domain: "Error at reading response", code: 3, userInfo: nil), endpoint)
                    return
                }
                
                // Parse the result as JSON, since that's what the API provides
                do {
                    guard let responseObj = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            failure(NSError(domain: "Error converting response to JSON", code: 4, userInfo: nil), endpoint)
                            return
                    }
                    
                    // The response object is a dictionary so we just access the title using the "status" key
                    guard let status = responseObj["status"] as? String else {
                        failure(NSError(domain: "Error getting status from response", code: 5, userInfo: nil), endpoint)
                        return
                    }
                    
                    success(status)
                } catch  {
                    failure(NSError(domain: "Error at converting response into JSON", code: 6, userInfo: nil), endpoint)
                    return
                }
            }
            task.resume()
        }
    }
}
