//
//  AutocompleteVM.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct AutocompleteVM {

    var locationName: String {
        return json["description"] as? String ?? "nope"
    }

    var searchTerm: String {
        let string = locationName.trimmingCharacters(in: .whitespaces)

        var parts = string.components(separatedBy: [","])
        let city = parts.first
        parts.remove(at: 0)

        var finalString = city

        parts.forEach {
            finalString?.append("," + $0.replacingOccurrences(of: " ", with: ""))
        }
        return finalString!
    }

    var json: JSON

    init(with json: JSON) {
        self.json = json
    }

}
