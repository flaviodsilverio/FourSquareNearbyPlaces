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

    var viewModel : VenueDetailsVM!
    
    @IBOutlet weak var mapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.center(mapOn: CLLocation(latitude: viewModel.coordinates.lat, longitude: viewModel.coordinates.lng))
        
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
    
//        UIApplication.shared.open(URL(string:"https://www.google.com/maps/@42.585444,13.007813,6z")!)
    //https://www.google.com/maps/?q=-15.623037,18.388672

}

extension VenueDetailsVC: MKMapViewDelegate {

    func center(mapOn location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
