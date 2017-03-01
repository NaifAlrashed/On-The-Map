//
//  Constants.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/21/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import MapKit
extension Convenience {
    
    static var sessionID = ""
    enum Path: String {
        case studentLocation = "/parse/classes/StudentLocation"
        case login = "/api/session"
        case userInfo = "/parse/classes/users/"
    }
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
        case put = "PUT"
    }
    static let ApiScheme = "https"
    struct Hosts {
        static let ParseLink = "parse.udacity.com"
        static let UdacityLink = "udacity.com"
    }
    
    static var pins = [MKPointAnnotation]()
    
    struct HTTPHeaderKeys {
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let RESTAPIKey = "X-Parse-REST-API-Key"
        static let contentType = "Content-Type"
    }
    
    struct HTTPHeaderValues {
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let contentTytpe = "application/json"
    }
}
