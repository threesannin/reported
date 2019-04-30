//
//  UpdateMapViewController.swift
//  Reported
//
//  Created by Sampson Liao on 4/30/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UpdateMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager! {
        didSet {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 100
            locationManager.requestWhenInUseAuthorization()
        }
    }
    var centerLocation: CLLocationCoordinate2D!
    var receivedLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.centerCoordinate = receivedLocation
        
        let region = MKCoordinateRegion(center: receivedLocation, latitudinalMeters: CLLocationDistance(exactly: 100)!, longitudinalMeters: CLLocationDistance(exactly: 100)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerLocation = mapView.centerCoordinate
        print("changed region: \(centerLocation.latitude), \(centerLocation.longitude)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
