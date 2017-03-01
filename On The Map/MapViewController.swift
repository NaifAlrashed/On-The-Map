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
        Convenience.shared.makeRequest(path: .studentLocation, method: .get, json: nil, completionHandler: { (theJson, error) in
            
            if let error = error {
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
                    print(pinObj)
                    Convenience.pins.append(pinObj)
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
        print("inside calloutAccessoryControlTapped")
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle {
                print("inside if let of that: \(url)")
                //let webView = storyboard?.instantiateViewController(withIdentifier: "webView")
                //UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
                let safari = SFSafariViewController(url: URL(string: url!)!)
                present(safari, animated: true, completion: nil)
            }
        }
    }
}

