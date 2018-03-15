//
//  GoogleAutoCompleteClient.swift
//  
//
//  Created by Flávio Silvério on 15/03/2018.
//

import Foundation

//https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Cambor&types=(cities)&key=AIzaSyCRZZ4rlzyJ0YISe3x2PUd2xwwiMhkKSUQ

protocol GoogleAutoCompleteDelegate: class {
    func success(with data: JSON)
}

final class GoogleAutoCompleteClient {

    let basepath = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input="
    let ending = "&types=(cities)&key=AIzaSyCRZZ4rlzyJ0YISe3x2PUd2xwwiMhkKSUQ"

    weak var delegate : GoogleAutoCompleteDelegate?

    let requestManager = RequestManager.shared

    func get(placeWith text: String) {

        guard let url = basepath + text + ending as? String else { return }

        requestManager.get(requestWith: url) { (success, data, error) in

            if success == true {
                self.delegate?.success(with: data!)
            }
        }
    }
}
