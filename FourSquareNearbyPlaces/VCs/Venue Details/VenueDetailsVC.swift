//
//  VenueDetailsVC.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 15/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit
import MapKit

final class VenueDetailsVC: UIViewController {

    var viewModel: VenueDetailsVM!

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var takeMeButton: UIButton!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueAddressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        takeMeButton.layer.cornerRadius = takeMeButton.frame.size.height / 2
        takeMeButton.layer.borderWidth = 2
        takeMeButton.layer.borderColor = UIColor.blue.cgColor
        takeMeButton.backgroundColor = .blue
        takeMeButton.setTitleColor(.white, for: .normal)

        venueNameLabel.text = viewModel.venueName
        venueAddressLabel.text = viewModel.venueLocation

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.mapView.center(on: viewModel.coordinates.lat, and: viewModel.coordinates.lng)

        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(
            latitude: viewModel.coordinates.lat,
            longitude: viewModel.coordinates.lng)

        annotation.coordinate = centerCoordinate
        annotation.title = viewModel.venueName
        self.mapView.addAnnotation(annotation)
    }

    @IBAction func takeMeAction(_ sender: UIButton) {

        guard let address = viewModel.mapAddress,
            let url = URL(string: address) else { return }

        UIApplication.shared.open(url)
    }
}
