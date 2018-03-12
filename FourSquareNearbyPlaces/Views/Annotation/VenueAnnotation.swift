//
//  VenueAnnotation.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 12/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit
import MapKit

class VenueAnnotation: MKAnnotationView {

    let textLabel : UILabel = UILabel()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        textLabel.frame = self.bounds
        self.backgroundColor = .red
        self.addSubview(textLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with vm: VenueVM) {
        textLabel.text = vm.venueName
    }
    
}
