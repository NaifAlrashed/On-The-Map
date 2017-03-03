//
//  StudentInformation.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/1/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//
import Foundation

struct StudentInformation {
    let createdAt: String?
    var firstName: String
    var lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String?
    let uniqueKey: String? //optional value not always available in json (according to udacity documentation)
    let updatedAt: String?
    
    init(json: [String:Any]) throws {
        guard let createdAt = json["createdAt"] as? String,
            let firstName = json["firstName"] as? String,
            let lastName = json["lastName"] as? String,
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double,
            let mapString = json["mapString"] as? String,
            let mediaURL = json["mediaURL"] as? String,
            let objectId = json["objectId"] as? String,
            let updatedAt = json["updatedAt"] as? String
            else {
                throw SerializationError.missing("couldn't unwrap json")
        }
        
        self.createdAt = createdAt
        self.firstName = firstName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.lastName = lastName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = json["uniqueKey"] as? String
        self.updatedAt = updatedAt
        
        if self.firstName == "" {
            self.firstName = "No"
        }
        
        if self.lastName == "" {
            self.lastName = "Name"
        }
        
    }
    //this init used when after posting a new location, to add it to the shared array to update the tableView
    init(createdAt: String?, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String?, uniqueKey: String?, updatedAt: String?) {
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
    }
    enum SerializationError: Error {
        case missing(String)
    }
}
