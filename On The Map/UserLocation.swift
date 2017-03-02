//
//  userLocation.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/2/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import MapKit

class UserLocation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
