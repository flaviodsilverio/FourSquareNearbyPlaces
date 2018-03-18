//
//  RequestManager.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

final class RequestManager {

    static let shared = RequestManager()

    let session = URLSession.shared

    func get(requestWith url: URL, _
        completion: @escaping ((_ success: Bool, _ data: JSON?, _ error: String?) -> Void)) {

        let request = URLRequest(url: url)

        perform(requestWith: request, completion)
    }

    private func perform(requestWith urlRequest: URLRequest, _
        completion: @escaping ((_ success: Bool, _ data: JSON?, _ error: String?) -> Void)) {

        session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                completion(false, nil, nil)
                return
            }
            switch urlResponse.statusCode {
            case 200:
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSON

                    DispatchQueue.main.async {
                        completion(true, json, nil)
                    }

                } catch let error as NSError {
                    DispatchQueue.main.async {
                        completion(false, nil, error.description)
                    }
                }
            default:
                DispatchQueue.main.async {
                    completion(false, nil, urlResponse.description)
                }
            }
            }.resume()
    }
}
