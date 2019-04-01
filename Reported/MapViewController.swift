//
//  MapViewController.swift
//  Reported
//
//  Created by Sampson Liao on 3/30/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapSearchBar: UISearchBar!
    
    
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var locationButton: UIButton!
    
    
    @IBOutlet weak var addButton: UIButton!
    
    
    var locationManager : CLLocationManager!
    var lastLocation : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        filterButton.layer.shadowRadius = 2
        filterButton.layer.shadowOpacity = 0.2
        
        locationButton.layer.shadowColor = UIColor.black.cgColor
        locationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        locationButton.layer.shadowRadius = 2
        locationButton.layer.shadowOpacity = 0.2
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addButton.layer.shadowRadius = 2
        addButton.layer.shadowOpacity = 0.2
        
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()

        
//        let mapCenter = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
//        let mapSpan = MKCoordinateSpan(latitudeDelta: <#T##CLLocationDegrees#>, longitudeDelta: <#T##CLLocationDegrees#>)
//        let region = MKCoordinateRegion(center: <#T##CLLocationCoordinate2D#>, span: <#T##MKCoordinateSpan#>)
//
//        mapView.setRegion(region, animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "New Location"
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title {
                print("Tapped \(String(describing: title)) pin")
            }
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        var annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var annotations = [mapView.userLocation, view.annotation]
        mapView.showAnnotations(annotations as! [MKAnnotation], animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location = locations.first as? CLLocation
        lastLocation = location?.coordinate
    }
    
    @IBAction func onLocationPRess(_ sender: UIButton) {
        var annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
    }
    
    
    @IBAction func onLongPressAdd(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        self.addPin(coordinate: coordinate)
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
