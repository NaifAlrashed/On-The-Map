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
            
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place, completionHandler: {(placeMarks, error) -> Void in
            guard let placeMark = placeMarks?.first else {
                DispatchQueue.main.async {
                    self.makeAndShowAlertView()
                }
                return
            }
            guard let twoDCoordinate = placeMark.location?.coordinate else {
                DispatchQueue.main.async {
                    self.makeAndShowAlertView()
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
    private func makeAndShowAlertView() {
        let alert = UIAlertController(title: "loacation not found", message: "please enter another location", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        place.text = ""
        loading.stopAnimating()
        loading.isHidden = true
        present(alert, animated: true, completion: nil)
    }
}
