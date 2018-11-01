//
//  PiHoleProxy.swift
//  Shortcuts for Pi-hole
//
//  Created by Lukas Wolfsteiner on 13.10.18.
//  Copyright © 2018 Lukas Wolfsteiner. All rights reserved.
//

import Cocoa

class PiHoleConnectionResult {
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

enum PiHoleAction {
    case Status
    case Enable
    case Disable
}

class PiHoleProxy: NSObject {

    public static func getBaseUrl(action: PiHoleAction = PiHoleAction.Status, seconds: Int = 0) -> URL? {
        let hostAddress = GeneralPreferences.getHostAddress()
        let hostPort = GeneralPreferences.getHostPort()
        let requestProtocol = GeneralPreferences.getRequestProtocol()
        let apiKey = GeneralPreferences.getApiKey()

        let base = requestProtocol + "://" + hostAddress! + ":" + String(hostPort)
        let path: String = "/admin/api.php"
        
        var urlString: String = base + path
        
        if action == PiHoleAction.Enable || action == PiHoleAction.Disable {
            urlString += "?auth=" + apiKey
            urlString += (action == PiHoleAction.Enable ? "&enable" : "&disable")
            
            if seconds > 0 {
                urlString += "=" + String(seconds)
            }
        } else {
            // PiHoleAction.Status
        }
        
        return URL(string: urlString)
    }

    public static func getConfigStatus() -> PiHoleConnectionResult {
        // check if host address is valid
        if (!GeneralPreferences.isHostAddressValid()) {
            return PiHoleConnectionResult.Negative(message: "Invalid Host Address")
        }

        // check if host port is valid
        if (!GeneralPreferences.isHostPortValid()) {
            return PiHoleConnectionResult.Negative(message: "Invalid Host Port")
        }

        // check if request protocol is valid
        if (!GeneralPreferences.isRequestProtocolValid()) {
            return PiHoleConnectionResult.Negative(message: "Invalid Protocol")
        }

        // check if api key is valid
        if (!GeneralPreferences.isApiKeyValid()) {
            return PiHoleConnectionResult.Negative(message: "Invalid API Key")
        }

        // check if timeout is valid
        if (!GeneralPreferences.isTimeoutValid()) {
            return PiHoleConnectionResult.Negative(message: "Invalid Timeout Value")
        }

        // define url on possible host
        if (getBaseUrl() == nil) {
            return PiHoleConnectionResult.Negative(message: "Invalid URL")
        }

        // config looks good!
        return PiHoleConnectionResult.Positive(message: "Configuration looks valid")
    }

    public static func getDefaultURLSession() -> URLSession {
        let config = URLSessionConfiguration.default
        let timeout = GeneralPreferences.getTimeout()

        // timeout 2s
        config.timeoutIntervalForRequest = TimeInterval(timeout)
        config.timeoutIntervalForResource = TimeInterval(timeout)

        return URLSession(configuration: config)
    }

    public static func performActionRequest(_ action: PiHoleAction, seconds: Int = 0, onSuccess success: @escaping (_ status: String) -> Void, onFailure failure: @escaping (_ error: NSError) -> Void) {

        do {
            guard let url = getBaseUrl(action: action, seconds: seconds) else {
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
                } catch {
                    failure(NSError(domain: "Error at converting response into JSON", code: 6, userInfo: nil))
                    return
                }
            }
            task.resume()
        }
    }
}
