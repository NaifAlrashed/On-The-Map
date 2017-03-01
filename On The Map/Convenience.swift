//
//  Convenience.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/22/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation

class Convenience {
    //to make the class a singleton
    static let shared = Convenience()
    private init () {}

    private func getNSMutableURLRequest(for path: Path, using httpMethod: HTTPMethod, json: String? = nil) -> NSMutableURLRequest {
        
        let request: NSMutableURLRequest
        let url: URL
        switch path {
        case .studentLocation where httpMethod == .get:
            url = buildURL(host: Hosts.ParseLink, parameters: nil, path: path.rawValue)
        case .studentLocation where httpMethod == .post:
            url = buildURL(host: Hosts.ParseLink, parameters: nil, path: path.rawValue)
        case .studentLocation where httpMethod == .put:
            url = buildURL(host: Hosts.ParseLink, parameters: nil, path: path.rawValue)
        case .login where httpMethod == .post:
            url = buildURL(host: Hosts.UdacityLink, parameters: nil, path: path.rawValue)
        case .login where httpMethod == .delete:
            url = buildURL(host: Hosts.UdacityLink, parameters: nil, path: path.rawValue)
        case .userInfo where httpMethod == .get:
            url = buildURL(host: Hosts.UdacityLink, parameters: nil, path: path.rawValue)
        default:
            url = URL(string: "https://facebook.com")!
            print("isn't supposed to reach this place")
        }
        print("the url to be used is: \(url)")
        request = NSMutableURLRequest(url: url)
        setHTTPHeader(for: request, path: path, HTTPMethod: httpMethod, json: json)
        print("httpMethod: \(request.httpMethod)")
        return request
    }
    
    private func setHTTPHeader(for request: NSMutableURLRequest,path: Path, HTTPMethod method: HTTPMethod, json: String?) {
//        var request = urlRequest
        request.httpMethod = method.rawValue
        if method == .delete {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            return
        }
        if path == .login && method == .post {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let json = json {
                print("httpMethod: \(request.httpMethod) url: \(request.url!) the json is not nil: \(json) the headers are: \(request.allHTTPHeaderFields)")
                request.httpBody = json.data(using: .utf8)
            }
            return
        }
        request.addValue(HTTPHeaderValues.ParseApplicationID, forHTTPHeaderField: HTTPHeaderKeys.ParseApplicationID)
        request.addValue(HTTPHeaderValues.RESTAPIKey, forHTTPHeaderField: HTTPHeaderKeys.RESTAPIKey)
        if method != .get {
            request.addValue(HTTPHeaderValues.contentTytpe, forHTTPHeaderField: HTTPHeaderKeys.contentType)
            if let json = json {
                request.httpBody = json.data(using: .utf8)
            }
        }
    }
    private func buildURL(host: String, parameters: [String:Any]?, path: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Convenience.ApiScheme
        components.host = host
        components.path = (path ?? "")
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
        
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    public func makeRequest(path: Path, method httpMethod: HTTPMethod, json: String?, completionHandler: @escaping (_ result: [String:Any]?, _ error: String?) -> Void) -> URLSessionTask {
        
        let request = getNSMutableURLRequest(for: path, using: httpMethod, json: json)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) in
            guard error == nil else {
                completionHandler(nil, "error != nil, this is the error: \(error)")
                return
            }
            
            guard var data = data else {
                completionHandler(nil, "data = nil")
                return
            }
            if path == .login {
                let range = Range(uncheckedBounds: (5, data.count))
                data = data.subdata(in: range)
            }
            
            let jsonResult: [String:Any]!
            
            do {
                jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)             as! [String:Any]
            } catch {
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                completionHandler(nil, "couldn't parse data to json")
                return
            }
            
            completionHandler(jsonResult, nil)
        }
        task.resume()
        return task
    }
    
    func unwrapJsonDiction(get key: String, from dictionary: [String:Any], error: String) -> Any {
        guard let value = dictionary[key] else {
            print(error)
            return ""
        }
        return value
    }
}
