//
//  VenuesVM.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
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

    var venueLat: Float {
        return venue.address.latitude
    }

    var venueLong: Float {
        return venue.address.longitude
    }

    init(with venue: Venue) {
        self.venue = venue
    }
}

final class VenuesPageVM {

    var childViewModels: [VenueVM] = []
    let client = FourSquareRequestClient()

    var completion : ((_ success: Bool, _ error: String?) -> Void)?

    var isCurrentLocation : Bool = true

    var currentCoordinates : (lat: Double, long: Double) = (0,0)

    var numberOfItems: Int {
        return childViewModels.count
    }

    func viewModel(forItemAt index: IndexPath) -> VenueVM {
        return childViewModels[index.row]
    }

    func search(forVenueLocated near: String?) {

        guard let near = near else {
            isCurrentLocation = true
            getData(near: nil)
            return
        }

        isCurrentLocation = false
        getData(near: near)
    }

    init() {
        client.delegate = self
    }

    func updateLocation(forLatitude lat: Double, andLongitude long: Double) {
        currentCoordinates = (lat, long)
        getData(near: nil)
    }
}

extension VenuesPageVM: RequestClientDelegate {

    func getData(near location: String?){

        if location != nil {

        } else {
            client.get(venuesForLatitude: currentCoordinates.lat, andLongitude: currentCoordinates.long)
        }
    }

    func requestSuccess(with data: JSON) {

        guard let jsonResponse = data["response"] as? JSON,
            let items = jsonResponse["venues"] as? [JSON]
            else { print("error"); return }

        items.forEach {
            childViewModels.append(VenueVM(with: Venue(with: $0)!))
        }
        completion?(true, nil)
    }

    func requestError(with text: String) {
    }
}
