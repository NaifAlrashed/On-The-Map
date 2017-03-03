//
//  Post.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/3/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//
import MapKit
class Post {
    func postAPin(placeName: String, linkInfo: String, coordinates: CLLocationCoordinate2D, completionHandler: @escaping (_ error: String?) -> Void) {
        let json = "{\"uniqueKey\": \"\(Convenience.key)\", \"firstName\": \"\(Convenience.personalInfo.firstName)\", \"lastName\": \"\(Convenience.personalInfo.lastName)\",\"mapString\": \"\(placeName)\", \"mediaURL\": \"\(linkInfo)\",\"latitude\": \(coordinates.latitude), \"longitude\": \(coordinates.longitude)}"
        
        let _ = Convenience.shared.makeRequest(path: .studentLocation, method: .post, json: json, completionHandler: { (json, error) in
            
            guard error == nil else {
                print("got an error in while new location \(error)")
                completionHandler(error)
                return
            }
            
            guard let json = json else {
                print("the json is nil!!!!")
                completionHandler("the json is nil!!!!")
                return
            }
            let newPin = StudentInformation.init(createdAt: nil, firstName: Convenience.personalInfo.firstName, lastName: Convenience.personalInfo.lastName, latitude: coordinates.latitude, longitude: coordinates.longitude, mapString: placeName, mediaURL: linkInfo, objectId: nil, uniqueKey: nil, updatedAt: nil)
            
            Convenience.pins.append(newPin)
            print("success in posting the location!!!: \(json)")
            completionHandler(nil)
        })
    }
}
