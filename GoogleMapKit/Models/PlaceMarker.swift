//
//  PlaceMarker.swift
//  GoogleMapKit
//
//  Created by xiong on 4/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    
    let place : GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = kGMSMarkerAnimationPop
    
    }

}
