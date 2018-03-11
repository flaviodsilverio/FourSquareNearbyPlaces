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
        completion: ((_ success: Bool,_ data: JSON, _ error: String)->())) {
        
        guard let url = URL(string: endpoint)  else { return }
        
        session.dataTask(with: url) { (data, urlResponse, error) in
            
            print(urlResponse as! HTTPURLResponse)
            
        }.resume()
        
        }
    
    
        
    }


