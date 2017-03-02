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
        getPins()
    }

    func getPins() {
        let _ = Convenience.shared.makeRequest(path: .studentLocation, method: .get, json: nil, completionHandler: { (theJson, error) in
            
            if let error = error {
                self.makeAndShowAlertView(message: "error", subMessage: "couldn't load data")
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
                    let studentInfo = try StudentInformation(json: result)
                    let studentPin = self.makePin(from: studentInfo)
                    Convenience.pins.append(studentInfo)
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(studentPin)
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
    
    @IBAction func postButtonPressed(_ sender: Any) {
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
//        let controller = storyboard?.instantiateViewController(withIdentifier: "PostView")
//            as! PostViewController
//        
//        present(controller, animated: true, completion: {
//            if controller.didCompleteposting {
//                DispatchQueue.main.async {
//                    self.mapView.addAnnotation(self.makePin(from: Convenience.pins.last!))
//                }
//            }
//        })
        performSegue(withIdentifier: "post", sender: nil)
    }
    private func makePin(from studentInfo: StudentInformation) -> Pin {
        return Pin(coordinate: CLLocationCoordinate2DMake(studentInfo.latitude, studentInfo.longitude), title: studentInfo.firstName + " " + studentInfo.lastName, subTitle: studentInfo.mediaURL)
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
