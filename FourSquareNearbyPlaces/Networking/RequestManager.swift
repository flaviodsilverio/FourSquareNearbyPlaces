//
//  RequestManager.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

final class RequestManager {

    static let shared = RequestManager()

    let session = URLSession.shared



    func post(requestWith endpoint: String, andQuery query: JSON,_
        completion: @escaping ((_ success: Bool,_ data: JSON?,_ error: String?) -> Void)){
        //There's no need for post requests on the current demo project, otherwise they'd be built here.
    }

    func get(requestWith endpoint: String,_
        completion: @escaping ((_ success: Bool,_ data: JSON?,_ error: String?) -> Void)) {

        guard let request = make(requestWith: endpoint) else {
            completion(false, nil, "")
            return
        }

        perform(requestWith: request, completion)
    }

    private func make(requestWith endpoint: String) -> URLRequest? {

        guard let url = URL(string: endpoint)  else { return nil }

        return URLRequest(url: url)
    }

    private func perform(requestWith urlRequest: URLRequest, _
        completion: @escaping ((_ success: Bool,_ data: JSON?,_ error: String?) -> Void)) {

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

                }
            case 400:
                print(urlRequest)
                break
            default:
                break
            }
            print(urlResponse.statusCode)
        }.resume()


        }
    }
