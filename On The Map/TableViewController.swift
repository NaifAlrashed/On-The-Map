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
    let tableNetworking = MapAndTableNetworkingModule()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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

    @IBAction func logout(_ sender: Any) {
        tableNetworking.logout(completionHandler: { isSuccessful in
            if isSuccessful {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.makeAndShowAlertView(message: "error", subMessage: "something went wrong")
            }
        })

    }

    @IBAction func post(_ sender: Any) {
        tableNetworking.downloadAndSetUserInfo()
        performSegue(withIdentifier: "post", sender: nil)
    }
}
