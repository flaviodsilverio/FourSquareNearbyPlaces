//
//  VenueListItemCell.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 11/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit

class VenueListItemCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func configure(with viewModel: VenueVM) {

        locationLabel.text = viewModel.venueLocation
        nameLabel.text = viewModel.venueName
    }
}
