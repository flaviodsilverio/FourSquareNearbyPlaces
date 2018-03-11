//
//  RequestManager.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

typealias JSON = [String:Any]

class RequestManager {
    
    static let shared = RequestManager()
    
    let session = URLSession.shared
    
    func perform(requestWith endpoint: String, completion
        completion: @escaping ((_ success: Bool,_ data: JSON?, _ error: String?)->())) {
        
        guard let url = URL(string: endpoint)  else { return }
        
        session.dataTask(with: url) { (data, urlResponse, error) in
            
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
                
                break
            case 404:
                break
            default:
                break
            }
            print(urlResponse.statusCode)
            
        }.resume()
        
        }
    
    
        
    }



