//
//  Venue.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct Venue {

    let id: String
    let name: String
    let address: AddressDetails
    //let iconLink: String

    init?(with json: JSON) {

        guard let id = json["id"] as? String, let name = json["name"] as? String else {
            return nil
        }

        self.id = id
        self.name = name
        self.address = AddressDetails(with: json["location"] as? JSON ?? [:])

        //guard let prefix = json[""]
    }
}

struct AddressDetails {

    let latitude: Double
    let longitude: Double
    let address: String
    let cc: String
    let city: String
    let state: String
    let country: String

    init(with json: JSON) {
        latitude = json["lat"] as? Double ?? 0.0
        longitude = json["lng"] as? Double ?? 0.0
        address = json["address"] as? String ?? "N/A"
        cc = json["cc"] as? String ?? "N/A"
        city = json["city"] as? String ?? "N/A"
        state = json["state"] as? String ?? "N/A"
        country = json["country"] as? String ?? "N/A"
    }
}
