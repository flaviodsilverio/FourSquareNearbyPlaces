//
//  VenuesVM.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation

struct VenueVM {
    
    fileprivate let venue : Venue
    
    var venueName : String
    { return venue.name }
    
    var venueLocation : String
    { return venue.address.address }
    
    init(with venue: Venue) {
        self.venue = venue
    }
    
}

class VenuesPageVM {
    
    var childViewModels : [VenueVM] = []
    let client = FourSquareRequestClient()
    
    var completion : ((_ success: Bool, _ error: String?)->())?
    
    var numberOfItems : Int {
        return childViewModels.count
    }
    
    func viewModel(forItem at: IndexPath) -> VenueVM {
        return childViewModels[at.row]
    }
    
    init() {
        
        client.delegate = self
        
        client.get(venuesForLatitude: 50.2156570, andLongitude: -5.2832920)
        RequestManager.shared.perform(requestWith: "") { (success: Bool, data: JSON?, error: String?) -> () in
            print("")
        }
    }
}

extension VenuesPageVM: RequestClientDelegate {
    
    func requestSuccess(with data: JSON) {

        guard let items = (data["response"] as! JSON)["venues"] as? [JSON] else { print("error"); return }
        
        items.forEach {
            childViewModels.append(VenueVM(with: Venue(with: $0)!))
        }
    
        completion?(true, nil)
        
    }
    
    func requestError(with text: String) {
        
    }
}
