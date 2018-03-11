//
//  ViewController.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 10/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit
import MapKit

class VenuesPageVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    
    let viewModel = VenuesPageVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "VenueListItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        viewModel.completion = {
            (success, error) in
            
            if success == true {
                self.tableView.reloadData()
            }
        }
        
        mapView.delegate = self
    }
    
    // MARK: - LocationManager delegate methods
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorized, .authorizedWhenInUse:
            
            manager.startUpdatingLocation()
            
            self.mapView.showsUserLocation = true
            
        default: break
        }
    }

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        mapView.setCenter((userLocation.location?.coordinate)!, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // mapView.setCenter((userLocation.location?.coordinate)!, animated: true)
        //print(locations)
        guard let location = locations.last else { return }
        
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
//
//        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: (latitude + 5) - (latitude - 5), longitudeDelta: (longitude + 5) - (longitude - 5)))
        
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    @IBAction func action(_ sender: Any) {
        locationManager.requestLocation()
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: 41, longitude:29)
        annotation.coordinate = centerCoordinate
        annotation.title = "Title"
        mapView.addAnnotation(annotation)
    }
    

}

extension VenuesPageVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? VenueListItemCell else { return UITableViewCell() }
        
        cell.configure(with: viewModel.viewModel(forItem: indexPath))
        
        return cell
    }
}

