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

    let mapNetworkingModule = MapAndTableNetworkingModule()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Convenience.pins = []
        getPins()
    }

    func getPins() {
        mapNetworkingModule.getPins(completionHandler: { (pin, error) in
            if error != nil {
                self.makeAndShowAlertView(message: "error", subMessage: "couldn't load data")
            } else {
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(pin!)
                }
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
            if let urlString = view.annotation?.subtitle,
                let url = URL(string: urlString!) {
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    

    @IBAction func logout(_ sender: Any) {
        mapNetworkingModule.logout(completionHandler: { isSuccessful in
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
        mapNetworkingModule.downloadAndSetUserInfo()
        performSegue(withIdentifier: "post", sender: nil)
    }
}
