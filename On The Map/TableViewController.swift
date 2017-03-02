//
//  TableViewController.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/22/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import SafariServices
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let safari = SFSafariViewController(url: URL(string: Convenience.pins[indexPath.row].mediaURL)!)
        present(safari, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Convenience.pins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = Convenience.pins[indexPath.row].firstName + " " + Convenience.pins[indexPath.row].lastName
        return cell
    }
    @IBAction func post(_ sender: Any) {
        let _ = Convenience.shared.makeRequest(path: .userInfo, method: .get, json: nil, completionHandler: { (json, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let json = json else {
                print("json is nil")
                return
            }
            
            guard let user = json["user"] as? [String:Any] else {
                print("couldn't get user from \(json)")
                return
            }
            guard let firstName = user["first_name"] as? String else {
                print("could't get first_name from \(json)")
                return
            }
            
            guard let lastName = user["last_name"] as? String else {
                print("could't get last_name from \(json)")
                return
            }
            
            print("first name: \(firstName), last name: \(lastName)")
            
            Convenience.personalInfo.firstName = firstName
            Convenience.personalInfo.lastName = lastName
        })
        performSegue(withIdentifier: "post", sender: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let _ = Convenience.shared.makeRequest(path: .login, method: .delete, json: nil, completionHandler: { (json, error) in
            
            guard error == nil else {
                print("got error: \(error)")
                return
            }
            
            guard let json = json else {
                print("json is nil!")
                return
            }
            
            print("got json!!!: \(json)")
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    private func makeAndShowAlertView(message: String, subMessage: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: subMessage, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
