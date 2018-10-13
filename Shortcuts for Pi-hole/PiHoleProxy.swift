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

enum PiHoleAction {
    case Status
    case Enable
    case Disable
}

class PiHoleProxy: NSObject {
    
    public static func getBaseUrl(action: PiHoleAction = PiHoleAction.Status) -> URL? {
        let hostAddress = GeneralPreferences.getHostAddress()
        let hostPort = GeneralPreferences.getHostPort()
        let requestProtocol = GeneralPreferences.getRequestProtocol()
        let apiKey = GeneralPreferences.getApiKey()
        
        var urlString = requestProtocol + "://" + hostAddress! + ":" + hostPort + "/admin/api.php?auth=" + apiKey
        
        if (action == PiHoleAction.Enable) {
            urlString = urlString + "&enable"
        } else if (action == PiHoleAction.Disable) {
            urlString = urlString + "&disable"
        }
        
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
        return ConnectionStatus(message: "Configuration looks valid", color: NSColor.green)
    }
    
    public static func getDefaultURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        // timeout 2s
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        
        return URLSession(configuration: config)
    }
    
    public static func performActionRequest(_ action: PiHoleAction, onSuccess success: @escaping (_ status: String) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        
        do {
            guard let url = getBaseUrl(action: action) else {
                failure(NSError(domain: "Error invalid endpoint", code: 1, userInfo: nil))
                return
            }
            
            let urlRequest = URLRequest(url: url)
            let session = getDefaultURLSession()
            
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                
                // Check for any errors
                guard error == nil else {
                    failure(NSError(domain: "Error at executing request (timeout)", code: 2))
                    return
                }
                
                // Make sure we got data
                guard let responseData = data else {
                    failure(NSError(domain: "Error at reading response", code: 3, userInfo: nil))
                    return
                }
                
                // Parse the result as JSON, since that's what the API provides
                do {
                    guard let responseObj = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            failure(NSError(domain: "Error converting response to JSON", code: 4, userInfo: nil))
                            return
                    }
                    
                    // The response object is a dictionary so we just access the title using the "status" key
                    guard let status = responseObj["status"] as? String else {
                        failure(NSError(domain: "Error getting status from response", code: 5, userInfo: nil))
                        return
                    }
                    
                    success(status)
                } catch  {
                    failure(NSError(domain: "Error at converting response into JSON", code: 6, userInfo: nil))
                    return
                }
            }
            task.resume()
        }
    }
}
