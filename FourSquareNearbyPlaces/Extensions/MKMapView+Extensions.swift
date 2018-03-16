//
//  MKMapView+Extensions.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 16/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    func center(on lat: Double, and lng: Double) {

        let location = CLLocation(latitude: lat, longitude: lng)

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  500, 500)
        self.setRegion(coordinateRegion, animated: true)

    }

}
