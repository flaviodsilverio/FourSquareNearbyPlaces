//
//  VenueDetailsVM.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 16/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct VenueDetailsVM {

    fileprivate let venueVM : VenueVM

    var mapAddress : String? {
        return "https://www.google.com/maps/?q=\(coordinates.lat),\(coordinates.lng)"
    }

    var venueName: String {
        return venueVM.venueName
    }

    var coordinates : (lat: Double, lng: Double) {
        return (venueVM.venueLat, venueVM.venueLong)
    }

    init(with venueVM: VenueVM) {

        self.venueVM = venueVM

    }
}
