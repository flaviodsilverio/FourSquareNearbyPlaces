//
//  RequestClient.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

protocol RequestClientDelegate: class {
    func requestSuccess(with data: JSON)
    func requestError(with text: String)
}

final class FourSquareRequestClient {

    //This client could be wya more flexible if we had those lets as injectable dependencies,
    //but for the demo purposes it won't be very flexible, it'll be very static.

    let secret = "3FCXEDF3AFTU5SG3OHXVYIQGJM2HNISMYGBHBB4VEHFDFBIG"
    let clientID = "FH0RMGQ2VXYS4PX1LTL5JBE0KUJ2MOU1QBTX5BXVBAXLSHSK"

    let basePath = "https://api.foursquare.com/v2/"
    let version = "20160607"

    weak var delegate: RequestClientDelegate?

    let requestManager = RequestManager.shared

    var currentRequest : URLRequest?

    func get(venuesForLatitude lat: Double,andLongitude long: Double){

        guard let endpoint = (basePath + "venues/search?ll=" + lat.description +
            "," + long.description + "&v=" + version + "&client_id="
            + clientID + "&client_secret=" + secret) as? String
        else { return }

        requestManager.get(requestWith: endpoint, { (success,data,error) in
            if success == true, data != nil {
                self.delegate?.requestSuccess(with: data!)
            }
        })
    }

    func get(venuesNear location: String){

        guard let endpoint = (basePath + "venues/search?near=" + location + "&v=" + version + "&client_id="
            + clientID + "&client_secret=" + secret) as? String
            else { return }
        
        requestManager.get(requestWith: endpoint, { (success,data,error) in
            if success == true, data != nil {
                self.delegate?.requestSuccess(with: data!)
            }
        })
    }
}
