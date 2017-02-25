//
//  Convenience.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/22/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation

class Convenience {
    static let shared = Convenience()
//    class func getInstance() -> Convenience {
//        return shared
//    }
    private init () {
    }

    private func getURLRequest(for path: Path, using httpMethod: HTTPMethod, json: String? = nil) -> URLRequest {
        
        let request: URLRequest
        let url: URL
        switch path {
        case .studentLocation where httpMethod == .get:
            url = buildURL(host: Hosts.ParseLink, parameters: [String:Any](), path: path.rawValue)
        case .studentLocation where httpMethod == .post:
            url = buildURL(host: Hosts.ParseLink, parameters: [String:Any](), path: path.rawValue)
        case .studentLocation where httpMethod == .put:
            url = buildURL(host: Hosts.ParseLink, parameters: [String:Any](), path: path.rawValue)
        case .login where httpMethod == .post:
            url = buildURL(host: Hosts.UdacityLink, parameters: [String:Any](), path: path.rawValue)
        case .login where httpMethod == .delete:
            url = buildURL(host: Hosts.UdacityLink, parameters: [String:Any](), path: path.rawValue)
        case .userInfo where httpMethod == .get:
            url = buildURL(host: Hosts.UdacityLink, parameters: [String:Any](), path: path.rawValue)
        default:
            url = URL(string: "https://google.com")!
            print("isn't supposed to reach this place")
        }
        print("the url to be used is: \(url)")
        request = URLRequest(url: url)
        setHTTPHeader(for: request, path: path, HTTPMethod: httpMethod, json: json)
        return request
    }
    
    private func setHTTPHeader(for urlRequest: URLRequest,path: Path, HTTPMethod method: HTTPMethod, json: String?) {
        var request = urlRequest
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
        if path == .login {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
    private func buildURL(host: String, parameters: [String:Any], path: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Convenience.ApiScheme
        components.host = host
        components.path = (path ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    public func makeRequest(path: Path, method httpMethod: HTTPMethod, json: String?, completionHandler: @escaping (_ result: [String:Any]?, _ error: String?) -> Void) -> URLSessionTask {
        
        let request = getURLRequest(for: path, using: httpMethod, json: json)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard error == nil else {
                completionHandler(nil, "error != nil, this is the error: \(error)")
                return
            }
            
            guard let data = data else {
                completionHandler(nil, "data = nil")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range)
            
            let jsonResult: [String:Any]!
            
            do {
                jsonResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)             as! [String:Any]
            } catch {
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
                completionHandler(nil, "couldn't parse data to json")
                return
            }
            
            completionHandler(jsonResult, nil)
        }
        task.resume()
        return task
    }
}
