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
    @IBOutlet weak var venuesTableView: UITableView!
    @IBOutlet weak var autoCompleteTableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    var locationManager = CLLocationManager()

    let viewModel = VenuesPageVM()

    var autocompleteIsVisible: Bool = false {
        didSet {
            if autocompleteIsVisible {
                self.view.bringSubview(toFront: autoCompleteTableView)
            } else {
                self.view.sendSubview(toBack: autoCompleteTableView)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "VenueListItemCell", bundle: nil)
        venuesTableView.register(nib, forCellReuseIdentifier: "venueCell")

        venuesTableView.estimatedRowHeight = 80
        venuesTableView.rowHeight = UITableViewAutomaticDimension

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()

        autocompleteIsVisible = false

        mapView.delegate = self

        viewModel.dataUpdated = {
            [unowned self] (success, error) in

            if success == true {

                self.venuesTableView.reloadData()

                self.viewModel.venuesViewModels.forEach { item in

                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(
                        latitude: item.venueLat,
                        longitude: item.venueLong)

                    annotation.coordinate = centerCoordinate
                    annotation.title = item.venueName
                    self.mapView.addAnnotation(annotation)
                }

                self.center(mapOn: CLLocation(latitude: self.viewModel.currentCoordinates.lat,
                                              longitude: self.viewModel.currentCoordinates.long))
            } else if error != nil {

                let alertView = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.show(alertView, sender: self)
            }
        }

        viewModel.autocompletionUpdated = {
            [weak self] in
            self?.autoCompleteTableView.stopLoading()
            self?.autoCompleteTableView.reloadData()
        }

        locationManager.requestLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vm = sender as? VenueVM,
            let destination = segue.destination as? VenueDetailsVC
            else {
                return
        }

        destination.viewModel = VenueDetailsVM(with: vm)

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

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.searchBar.resignFirstResponder()
    }
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

        guard let location = locations.last else { return }

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
                                                                 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension VenuesPageVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == venuesTableView {
            return viewModel.numberOfVenues
        } else {
            return viewModel.numberOfAutocompletions
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == venuesTableView {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell") as? VenueListItemCell
                else { return UITableViewCell() }

            cell.configure(with: viewModel.viewModel(forVenueAt: indexPath))

            return cell

        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "autocompleteCell")
                else { return UITableViewCell() }

            cell.textLabel?.text = viewModel.autoCompleteViewModels[indexPath.row].locationName

            return cell

        }
    }
}

extension VenuesPageVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == autoCompleteTableView {
            viewModel.didSelect(autocompleteItemAt: indexPath)
            autocompleteIsVisible = false
        } else {
            self.performSegue(withIdentifier: "showVenueDetails", sender: viewModel.viewModel(forVenueAt: indexPath))
        }
    }

}

extension VenuesPageVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(forVenueLocated: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            autocompleteIsVisible = false
        } else {
            autoCompleteTableView.startLoading()
            autocompleteIsVisible = true
        }

        viewModel.searchText = searchText
    }
}
