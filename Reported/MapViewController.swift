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

final class IssueAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
//    var currentMapSnapShotImage: UIImage?
    
    var locationManager : CLLocationManager!
    var lastLocation : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
        let annotation = IssueAnnotation(coordinate: coordinate, title: "NewLocation", subtitle: "subtitle")
        mapView.addAnnotation(annotation)
        // mapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title {
                print("Tapped \(String(describing: title)) pin")
            }
        }
    }
    
    // Update map view to center on user location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
        lastLocation = userLocation.coordinate
        print("didUpdate")

    }
    
    // Update map view to center on user and annotation
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // let annotations = [mapView.userLocation, view.annotation]
        // mapView.showAnnotations(annotations as! [MKAnnotation], animated: true)
//        for annotation in mapView.annotations {
//            if annotation.title == "NewLocation" {
//                mapView.removeAnnotation(annotation)
//            }
//        }
        
        if let annotation = view.annotation {
            self.mapView.removeAnnotation(annotation)
        }
       
        print("deselect")
    }
    
    // Allow updates to location when moving
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        print("didChangeAuthStatus")

    }
    
    // get last location when location is updated
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.first as? CLLocation
        lastLocation = location?.coordinate
        print("4")
    }
    
//    func takeSnapshot() {
//        let snapOption = MKMapSnapshotter.Options()
//        var mapRegion = MKCoordinateRegion()
//        mapRegion.center = mapView.centerCoordinate
//        snapOption.region = mapRegion
//        let snapshotter = MKMapSnapshotter(options: snapOption)
//        snapshotter.start {snapshot,error in
//            DispatchQueue.main.async {
//                self.currentMapSnapShotImage = snapshot?.image
//            }
//        }
//    }
   
    
    
    @IBAction func onLocationPRess(_ sender: UIButton) {
        let annotations = [mapView.userLocation]
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
    
  
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationNavigationController = segue.destination as! UINavigationController
        let formViewController = destinationNavigationController.topViewController as! FormViewController
        
        let mapSnapshotImage = mapView.pbtakesnap()
        formViewController.mapSnapshotImage = mapSnapshotImage
        formViewController.pinLocation = lastLocation
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let issueAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            issueAnnotation.animatesWhenAdded = true
            issueAnnotation.titleVisibility = .adaptive
            issueAnnotation.subtitleVisibility = .adaptive
            return issueAnnotation
        }
        return nil
    }
}
extension UIView {
    func pbtakesnap() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
