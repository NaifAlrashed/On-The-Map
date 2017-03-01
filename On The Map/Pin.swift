//
//  Pin.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/28/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import MapKit
class Pin: NSObject, MKAnnotation {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init(pinObj: [String:Any]) throws {
        guard let createdAt = pinObj["createdAt"] as? String,
        let firstName = pinObj["firstName"] as? String,
        let lastName = pinObj["lastName"] as? String,
        let latitude = pinObj["latitude"] as? Double,
        let longitude = pinObj["longitude"] as? Double,
        let mapString = pinObj["mapString"] as? String,
        let mediaURL = pinObj["mediaURL"] as? String,
        let objectId = pinObj["objectId"] as? String,
        let uniqueKey = pinObj["uniqueKey"] as? String,
        let updatedAt = pinObj["updatedAt"] as? String
        else {
            throw SerializationError.missing("couldn't unwrap json")            
        }
        
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.title = firstName + " " + lastName
        self.subtitle = mediaURL
    }
    
    enum SerializationError: Error {
        case missing(String)
    }
}
