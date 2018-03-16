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

struct AutocompleteVM {

    var locationName : String {
        return json["description"] as? String ?? "nope"
    }
    
    var searchTerm: String {
//        let string = locationName.trimmingCharacters(in: .whitespaces)
 //       print(string)
        return locationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }

    var json : JSON

    init(with json: JSON) {
        self.json = json
    }

}

final class VenuesPageVM {

    var venuesViewModels: [VenueVM] = []
    var autoCompleteViewModels: [AutocompleteVM] = []

    let fourSquareClient = FourSquareRequestClient()
    let googleClient = GoogleAutoCompleteClient()

    var completion : ((_ success: Bool, _ error: String?) -> Void)?

    var isCurrentLocation : Bool = true

    var currentCoordinates : (lat: Double, long: Double) = (0,0)

    var searchText : String = "" {
        didSet {
            googleClient.get(placeWith: searchText)
        }
    }

    var numberOfVenues: Int {
        return venuesViewModels.count
    }

    func viewModel(forVenueAt index: IndexPath) -> VenueVM {
        return venuesViewModels[index.row]
    }

    var numberOfAutocompletions: Int {
        return autoCompleteViewModels.count
    }

    func search(forVenueLocated near: String) {

        if near == "" {
            isCurrentLocation = true
            getData(near: nil)
        } else {
            isCurrentLocation = false
            getData(near: near)
        }
    }

    init() {
        googleClient.delegate = self
        fourSquareClient.delegate = self
    }

    func updateLocation(forLatitude lat: Double, andLongitude long: Double) {
        currentCoordinates = (lat, long)
        getData(near: nil)
    }

    func didSelect(autocompleteItemAt index: IndexPath) {

        isCurrentLocation = false

        self.getData(near: autoCompleteViewModels[index.row].searchTerm)

    }
}

extension VenuesPageVM: FourSquareRequestClientDelegate {

    func getData(near location: String?) {

        print(location)
        
        guard let location = location else {
            fourSquareClient.get(venuesForLatitude: currentCoordinates.lat, andLongitude: currentCoordinates.long)
            return
        }
        fourSquareClient.get(venuesNear: location)
    }

    func fourSquareRequest(successWith data: JSON) {

        guard let jsonResponse = data["response"] as? JSON,
            let items = jsonResponse["venues"] as? [JSON]
            else { print("error"); return }
        
        if isCurrentLocation == false {
            guard let geocode = jsonResponse["geocode"] as? JSON,
            let feature = geocode["feature"] as? JSON,
            let geometry = feature["geometry"] as? JSON,
            let center = geometry["center"] as? JSON,
            let lat = center["lat"] as? Double,
                let lng = center["lng"] as? Double else {
                    return
            }
            currentCoordinates = (lat,lng)
        }

        venuesViewModels = []
        
        items.forEach {
            venuesViewModels.append(VenueVM(with: Venue(with: $0)!))
        }
        completion?(true, nil)
    }

    func fourSquareRequest(errorWith text: String) {
    }
}

extension VenuesPageVM: GoogleAutoCompleteDelegate {

    func success(with data: JSON) {

        guard let items = data["predictions"] as? [JSON] else { return }

        autoCompleteViewModels = []

        items.forEach {
            autoCompleteViewModels.append(AutocompleteVM(with: $0))
        }

        completion?(true, nil)
    }
}


