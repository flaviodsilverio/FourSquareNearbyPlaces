//
//  ViewController.swift
//  FourSquareNearbyPlaces
//
//  Created by Flávio Silvério on 10/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    

    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        //var request = URLRequest(url: URL(string: )!)
//        request.addValue("FH0RMGQ2VXYS4PX1LTL5JBE0KUJ2MOU1QBTX5BXVBAXLSHSK", forHTTPHeaderField: "client_id")
//        request.addValue("3FCXEDF3AFTU5SG3OHXVYIQGJM2HNISMYGBHBB4VEHFDFBIG", forHTTPHeaderField: "client_secret")
        
//        session.dataTask(with: request) { (data, response, error) in
//            
//            print(response as! HTTPURLResponse)
//            
//        }.resume()
        
        /*
         client_id: 'CLIENT_ID',
         client_secret: 'CLIENT_SECRET'
         */
        
        RequestManager.shared.perform(requestWith: "") { (success: Bool, data: JSON) -> () in
            print("")
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

