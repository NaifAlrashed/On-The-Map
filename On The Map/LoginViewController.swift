//
//  LoginViewController.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/22/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginButtonPressed(_ sender: Any) {
        let theEmail = email.text
        let pass = password.text
        let json = "{\"udacity\": {\"username\": \"\(theEmail)\", \"password\": \"\(pass)\"}}"
        let _ = Convenience.shared.makeRequest(path: .login, method: .post, json: json, completionHandler: { (theJson, error) in
            if error != nil {
                print("this message runs in the completion handler for LoginViewController\(error!)")
            } else {
                print(theJson!)
            }
        })
    }

}
