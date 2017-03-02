//
//  ViewController.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/21/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getPins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getPins() {
        let _ = Convenience.shared.makeRequest(path: .studentLocation, method: .get, json: nil, completionHandler: { (theJson, error) in
            
            if let error = error {
                //TODO: make alertView
                print("this is in mapViewController, and error is: \(error)")
                return
            }
            
            guard let theJson = theJson else {
                print("theJson is nil")
                return
            }
            
            guard let results = theJson["results"] as? [[String:Any]] else {
                print("couldn't find results in \(theJson)")
                return
            }
            
            for result in results {
                do {
                    let pinObj = try Pin(pinObj: result)
                    print(pinObj.updatedAt)
                    let studentInfo = StudentInformation(firstName: pinObj.firstName, lastName: pinObj.lastName, latitude: pinObj.latitude, longitude: pinObj.longitude, mediaURL: pinObj.mediaURL)
                    Convenience.pins.append(studentInfo)
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(pinObj)
                    }
                } catch {
                    print("++++++++++++++++++++++++++++++++++++++++++++++++++ couldn't do it++++++++++++++")
                    print(result)
                    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                }
                
                print("----------------------------------------------------------------------")
            }
        })
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"

        if annotation is Pin {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle {
                let safari = SFSafariViewController(url: URL(string: url!)!)
                present(safari, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
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
        })
    }
    
}

