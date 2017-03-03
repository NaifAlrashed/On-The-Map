//
//  PostViewController.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/1/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostViewController: UIViewController {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var place: UITextField!
    var coordinates: CLLocationCoordinate2D? = nil
    
    let postNewPin = Post()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loading.isHidden = true
        mapView.isHidden = true
        postButton.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }

    @IBAction func findPlace(_ sender: Any) {
        loading.isHidden = false
        loading.startAnimating()
        
        guard let place = place?.text else {
            DispatchQueue.main.async {
                self.makeAndShowAlertView(message: "loacation not found", subMessage: "please enter another location")
                self.loading.isHidden = true
                self.loading.stopAnimating()
            }
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place, completionHandler: {(placeMarks, error) -> Void in
            guard let placeMark = placeMarks?.first else {
                DispatchQueue.main.async {
                    self.makeAndShowAlertView(message: "loacation not found", subMessage: "please enter another location")
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                }
                return
            }
            guard let twoDCoordinate = placeMark.location?.coordinate else {
                DispatchQueue.main.async {
                    self.makeAndShowAlertView(message: "loacation not found", subMessage: "please enter another location")
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                }
                return
            }
            self.coordinates = twoDCoordinate
            let annotation = Pin(coordinate: self.coordinates!, title: self.place.text, subTitle: nil)
            DispatchQueue.main.async {
                self.loading.stopAnimating()
                self.toggleAppearance()
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }
    
    @IBAction func post(_ sender: Any) {
        loading.isHidden = false
        loading.startAnimating()
        
        guard let coordinates = coordinates,
            let placeName = place.text else {
            DispatchQueue.main.async {
                self.makeAndShowAlertView(message: "error", subMessage: "didn't find data entered earlier, please cancel operation")
            }
            return
        }
        
        guard let linkInfo = link.text else {
            DispatchQueue.main.async {
                self.makeAndShowAlertView(message: "No Link!", subMessage: "please provide a link, so others can know who you are!")
            }
            return
        }
        postNewPin.postAPin(placeName: placeName, linkInfo: linkInfo, coordinates: coordinates, completionHandler: { error in
            if let error = error {
                self.makeAndShowAlertView(message: "error", subMessage: "something went wrong")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
        
    }
    private func toggleAppearance() {
        loading.isHidden = !loading.isHidden
        mapView.isHidden = !mapView.isHidden
        postButton.isHidden = !postButton.isHidden
        findButton.isHidden = !findButton.isHidden
        link.isHidden = !link.isHidden
        place.isHidden = !place.isHidden
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
