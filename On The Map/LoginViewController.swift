//
//  LoginViewController.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/22/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit
class LoginViewController: UIViewController {

    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loading.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        performUpdatesOnUI(errorString: nil, shouldPerformSeque: false)
        let theEmail = email.text!
        let pass = password.text!
        print("\(theEmail)  \(pass)")
        let json = "{\"udacity\": {\"username\": \"\(theEmail)\", \"password\": \"\(pass)\"}}"
        print(json)
        let _ = Convenience.shared.makeRequest(path: .login, method: .post, json: json, completionHandler: { (theJson, error) in
            guard error == nil else {
                print("this message runs in the completion handler for LoginViewController\(error)")
                DispatchQueue.main.async {
                    self.performUpdatesOnUI(errorString: "recieved error in response", shouldPerformSeque: false)
                }
                return
            }
            guard let sessionObject = theJson?["session"] as? [String:Any] else {
                print("couldn't get sessionObject from: \(theJson)")
                DispatchQueue.main.async {
                    self.performUpdatesOnUI(errorString: "unexpected error", shouldPerformSeque: false)
                }
                return
            }
            
            guard let accountObject = theJson?["account"] as? [String:Any] else {
                print("couldn't get account from: \(theJson)")
                DispatchQueue.main.async {
                    self.performUpdatesOnUI(errorString: "unexpected error", shouldPerformSeque: false)
                }
                return
            }
            
            guard let isRegistered = accountObject["registered"] as? Bool else {
                print("couldn't get registered from: \(accountObject)")
                DispatchQueue.main.async {
                    self.performUpdatesOnUI(errorString: "unexpected error", shouldPerformSeque: false)
                }
                return
            }
            
            guard isRegistered else {
                print("you are not registered!!!: \(isRegistered): \(theJson)")
                DispatchQueue.main.async {
                    self.performUpdatesOnUI(errorString: "incorrect Email and/or Password", shouldPerformSeque: false)
                }
                return
            }
            
            guard let sessionID = sessionObject["id"] as? String else {
                print("couldn't get id from: \(sessionObject)")
                DispatchQueue.main.async {
                    self.performUpdatesOnUI(errorString: "unexpected error", shouldPerformSeque: false)
                }
                return
            }
            
            print("got session id, the whole json is: \(theJson)")
            Convenience.sessionID = sessionID
            DispatchQueue.main.async {
                self.performUpdatesOnUI(errorString: nil, shouldPerformSeque: true)
            }
        })
    }
    
    private func performUpdatesOnUI(errorString: String?, shouldPerformSeque: Bool) {
        loading.isHidden = !loading.isHidden
        if loading.isAnimating {
            loading.stopAnimating()
        } else {
            loading.startAnimating()
        }
        
        if let errorString = errorString {
            error?.text = errorString
        }
        
        if shouldPerformSeque {
            performSegue(withIdentifier: "tabBar", sender: nil)
        }
        
    }
    
    
}

