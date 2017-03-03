//
//  Login.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/3/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

class Login {
    func loginRequest(pass: String, theEmail: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let json = "{\"udacity\": {\"username\": \"\(theEmail)\", \"password\": \"\(pass)\"}}"
        print(json)
        let _ = Convenience.shared.makeRequest(path: .login, method: .post, json: json, completionHandler: { (theJson, error) in
            guard error == nil else {
                completionHandler(false, error)
                return
            }
            guard let sessionObject = theJson?["session"] as? [String:Any] else {
                completionHandler(false, "couldn't get sessionObject from: \(theJson)")
                return
            }
            
            guard let accountObject = theJson?["account"] as? [String:Any] else {
                completionHandler(false, "couldn't get account from: \(theJson)")
                return
            }
            
            guard let isRegistered = accountObject["registered"] as? Bool else {
                completionHandler(false, "couldn't get registered from: \(accountObject)")
                return
            }
            
            guard isRegistered else {
                completionHandler(false, "incorrect Email and/or Password")
                return
            }
            
            guard let key = accountObject["key"] as? String else {
                completionHandler(false, "couldn't get key from: \(accountObject)")
                return
            }
            
            guard let sessionID = sessionObject["id"] as? String else {
                completionHandler(false, "couldn't get id from: \(sessionObject)")
                return
            }
            
            Convenience.sessionID = sessionID
            Convenience.key = key
            completionHandler(true, nil)
            
        })

    }
}
