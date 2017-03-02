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
    var didCompleteposting = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
        let json = "{\"uniqueKey\": \"\(Convenience.key)\", \"firstName\": \"\(Convenience.personalInfo.firstName)\", \"lastName\": \"\(Convenience.personalInfo.lastName)\",\"mapString\": \"\(placeName)\", \"mediaURL\": \"\(linkInfo)\",\"latitude\": \(coordinates.latitude), \"longitude\": \(coordinates.longitude)}"
        
        let _ = Convenience.shared.makeRequest(path: .studentLocation, method: .post, json: json, completionHandler: { (json, error) in
            
            guard error == nil else {
                print("got an error in while new location \(error)")
                return
            }
            
            guard let json = json else {
                print("the json is nil!!!!")
                return
            }
            let newPin = StudentInformation.init(createdAt: nil, firstName: Convenience.personalInfo.firstName, lastName: Convenience.personalInfo.lastName, latitude: coordinates.latitude, longitude: coordinates.longitude, mapString: placeName, mediaURL: linkInfo, objectId: nil, uniqueKey: nil, updatedAt: nil)
            
            Convenience.pins.append(newPin)
            print("success in posting the location!!!: \(json)")
            self.didCompleteposting = true
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
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
    private func makeAndShowAlertView(message: String, subMessage: String) {
        let alert = UIAlertController(title: message, message: subMessage, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        place.text = ""
        loading.stopAnimating()
        loading.isHidden = true
        present(alert, animated: true, completion: nil)
    }
}
