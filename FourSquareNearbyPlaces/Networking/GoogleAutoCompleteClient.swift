//
//  GoogleAutoCompleteClient.swift
//  
//
//  Created by Flávio Silvério on 15/03/2018.
//

import Foundation

protocol GoogleAutoCompleteDelegate: class {
    func success(with data: JSON)
}

final class GoogleAutoCompleteClient {

    let basepath = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    let key = "AIzaSyCRZZ4rlzyJ0YISe3x2PUd2xwwiMhkKSUQ"

    weak var delegate: GoogleAutoCompleteDelegate?

    let requestManager = RequestManager.shared

    func get(placeWith text: String) {

        var urlComponents = URLComponents(string: basepath)

        urlComponents?.queryItems = [
            URLQueryItem(name: "input", value: text),
            URLQueryItem(name: "types", value: "(cities)"),
            URLQueryItem(name: "key", value: key)
        ]

        guard let url = urlComponents?.url else { return }

        requestManager.get(requestWith: url) { (success, data, error) in

            if success == true {
                self.delegate?.success(with: data!)
            } else {
                //should send an error message to the user
                print(error ?? "")
            }
        }
    }
}
