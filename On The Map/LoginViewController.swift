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
    
    let loginNetworking = Login()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loading.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        error.text = ""
        password.text = ""
        email.text = ""
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        performUpdatesOnUI(errorString: nil, shouldPerformSeque: false)
        let theEmail = email.text!
        let pass = password.text!
        print("\(theEmail)  \(pass)")
        
        loginNetworking.loginRequest(pass: pass, theEmail: theEmail, completionHandler: { (isSuccessful, error) in
            if error != nil {
                self.performUpdatesOnUI(errorString: error, shouldPerformSeque: false)
            } else {
                self.performUpdatesOnUI(errorString: nil, shouldPerformSeque: true)
            }
        })
    }
    
    private func performUpdatesOnUI(errorString: String?, shouldPerformSeque: Bool) {
        DispatchQueue.main.async {
            self.loading.isHidden = !self.loading.isHidden
            if self.loading.isAnimating {
                self.loading.stopAnimating()
            } else {
                self.loading.startAnimating()
            }
            
            if let errorString = errorString {
                if errorString != "incorrect Email and/or Password" && errorString != "response is not 2xx, and it is: 403" {
                    self.makeAndShowAlertView(message: "error", subMessage: "something went wrong")
                }
                else {
                    self.makeAndShowAlertView(message: "invalid credentials", subMessage: "invalid Email and/or Password")
                }
            }
            
            if shouldPerformSeque {
                self.performSegue(withIdentifier: "tabBar", sender: nil)
            }
        }
    }
}

