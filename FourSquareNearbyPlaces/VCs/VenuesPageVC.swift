//
//  ViewController.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 10/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit
import MapKit

class VenuesPageVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    var locationManager = CLLocationManager()

    let viewModel = VenuesPageVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "VenueListItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")

        mapView.register(VenueAnnotation.self, forAnnotationViewWithReuseIdentifier: "annotationView")
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()

        viewModel.completion = {
            (success, error) in

            if success == true {
                self.tableView.reloadData()

                self.viewModel.childViewModels.forEach { item in

                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(
                        latitude: Double(item.venueLat),
                        longitude: Double(item.venueLong))

                    annotation.coordinate = centerCoordinate
                    annotation.title = item.venueName
                    self.mapView.addAnnotation(annotation)

                }

            }
        }

        mapView.delegate = self
    }

    // MARK: - LocationManager delegate methods

    @IBAction func action(_ sender: Any) {
        locationManager.requestLocation()
    }
}

extension VenuesPageVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        mapView.setCenter((userLocation.location?.coordinate)!, animated: true)

        guard let latitude = userLocation.location?.coordinate.latitude,
            let longitude = userLocation.location?.coordinate.longitude
            else { return }

        viewModel.updateLocation(forLatitude: latitude, andLongitude: longitude)
    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard let annotationView = mapView.dequeueReusableAnnotationView(
//    withIdentifier: "annotationView") as? VenueAnnotation else { return nil }
//
//        annotationView.configure(with: VenueVM(with: Venue(with: venue())!))
//
//        return annotationView
//    }
}

extension VenuesPageVC: CLLocationManagerDelegate {

    private func locationManager(manager: CLLocationManager!,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {

        case .authorized, .authorizedWhenInUse:

            manager.startUpdatingLocation()

            self.mapView.showsUserLocation = true

        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*        let annotation = MKPointAnnotation()
         let centerCoordinate = CLLocationCoordinate2D(latitude: 41, longitude:29)
         annotation.coordinate = centerCoordinate
         annotation.title = "Title"
         mapView.addAnnotation(annotation)*/
        guard let location = locations.last else { return }

        //mapView.setCenter(location.coordinate, animated: true)

        center(mapOn: location)

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        viewModel.updateLocation(forLatitude: latitude, andLongitude: longitude)
    }

    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func center(mapOn location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? VenueListItemCell
            else { return UITableViewCell() }

        cell.configure(with: viewModel.viewModel(forItemAt: indexPath))

        return cell
    }
}

extension VenuesPageVC {
    func venue() -> JSON {
        return  ["id": "4fb147e9e4b08885003346dd",
        "name": "pengegon institute",
        "location": [
            "address": "Pengegon",
            "lat": 50.21542970853104,
            "lng": -5.283300233794709,
            "labeledLatLngs": [
            [
            "label": "display",
            "lat": 50.21542970853104,
            "lng": -5.283300233794709
            ]
            ],
            "distance": 30,
            "cc": "GB",
            "city": "Camborne",
            "state": "Cornualha",
            "country": "Reino Unido",
            "formattedAddress": [
            "Pengegon",
            "Camborne",
            "Cornualha",
            "Reino Unido"
            ]
        ]
    ]
}
}
