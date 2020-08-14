//
//  DroppablePin.swift
//  Pixel City
//
//  Created by kamrujjaman Joy on 8/14/20.
//  Copyright © 2020 kamrujjaman Joy. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject,MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var identifier : String
    
    init(coordinate: CLLocationCoordinate2D, identifier:String){
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
}
