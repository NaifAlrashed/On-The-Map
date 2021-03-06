//
//  Pin.swift
//  On The Map
//
//  Created by Naif Alrashed on 2/28/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import MapKit
class Pin: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subTitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subTitle
    }
}
