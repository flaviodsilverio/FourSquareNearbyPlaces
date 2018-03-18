//
//  RequestClient.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

protocol FourSquareRequestClientDelegate: class {
    func fourSquareRequest(successWith data: JSON)
    func fourSquareRequest(errorWith text: String)
}

final class FourSquareRequestClient {

    //This client could be way more flexible if we had those lets as injectable dependencies,
    //but for the demo purposes it won't be very flexible, it'll be very static.

    let secret = "3FCXEDF3AFTU5SG3OHXVYIQGJM2HNISMYGBHBB4VEHFDFBIG"
    let clientID = "FH0RMGQ2VXYS4PX1LTL5JBE0KUJ2MOU1QBTX5BXVBAXLSHSK"

    let basePath = "https://api.foursquare.com/v2/"
    let version = "20160607"

    weak var delegate: FourSquareRequestClientDelegate?

    let requestManager = RequestManager.shared
    var currentRequest: URLRequest?

    func get(venuesForLatitude lat: Double, andLongitude long: Double) {

        get(requestWith: generate(urlWith: lat, long: long, andNear: nil))

    }

    func get(venuesNear location: String) {

        get(requestWith: generate(urlWith: nil, long: nil, andNear: location))

    }

    fileprivate func get(requestWith url: URL?) {

        guard let url = url else { return }

        requestManager.get(requestWith: url, { (success, data, error) in
            if success == true, data != nil {
                self.delegate?.fourSquareRequest(successWith: data!)
            } else {
                guard let error = error else { return }

                self.delegate?.fourSquareRequest(errorWith: error)
            }
        })
    }

    fileprivate func generate(urlWith lat: Double?, long lng: Double?, andNear location: String?) -> URL? {

        var urlComponents = URLComponents(string: basePath + "venues/search?")!

        urlComponents.queryItems = [
            URLQueryItem(name: "v", value: version),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: secret)
        ]

        if let location = location {
            urlComponents.queryItems?.append(URLQueryItem(name: "near", value: location))
        } else if let lat = lat, let lng = lng {
            urlComponents.queryItems?.append(URLQueryItem(name: "ll", value: lat.description + "," + lng.description))
        }

        return urlComponents.url
    }
}
