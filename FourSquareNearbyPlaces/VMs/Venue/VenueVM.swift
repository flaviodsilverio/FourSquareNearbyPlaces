//
//  VenueVM.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct VenueVM {

    fileprivate let venue: Venue

    var venueName: String {
        return venue.name
    }

    var venueLocation: String {
        return venue.address.address
    }

    var venueLat: Double {
        return venue.address.latitude
    }

    var venueLong: Double {
        return venue.address.longitude
    }

    init(with venue: Venue) {
        self.venue = venue
    }
}
