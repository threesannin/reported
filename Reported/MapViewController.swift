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
    var descripText: String!
    var dirOfTravel: String!
    var followUp: Bool!
    // var issueCategory: String?
    var issueImage: UIImage?
    var issueDateTime: NSDate!
    var nearestCrossStreet: String! // can be geo
    var transMode: String!
    var coordinate: CLLocationCoordinate2D
    var title: String?
 
    init(descripText: String!, dirOfTravel: String!, followUp: Bool!, issueCategory: String!, issueImage: UIImage?, issueDateTime: NSDate!, nearestCrossStreet: String!, transMode: String!, coordinate: CLLocationCoordinate2D, title: String?) {
        self.descripText = descripText
        self.dirOfTravel = dirOfTravel
        self.followUp = followUp
        // self.issueCategory = issueCategory
        if let issueImage = issueImage {
            self.issueImage = issueImage
        }
        self.issueDateTime = issueDateTime
        self.nearestCrossStreet = nearestCrossStreet
        self.transMode = transMode
        self.coordinate = coordinate
        self.title = issueCategory
        super.init()
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton! {
        didSet {
            filterButton.layer.shadowColor = UIColor.black.cgColor
            filterButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            filterButton.layer.shadowRadius = 2
            filterButton.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            locationButton.layer.shadowColor = UIColor.black.cgColor
            locationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            locationButton.layer.shadowRadius = 2
            locationButton.layer.shadowOpacity = 0.2
        }
    }
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.layer.shadowColor = UIColor.black.cgColor
            addButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            addButton.layer.shadowRadius = 2
            addButton.layer.shadowOpacity = 0.2
            
        }
    }
    //    var currentMapSnapShotImage: UIImage?
    
    var pickedImage: UIImage?
    var locationManager : CLLocationManager! {
        didSet {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 100
            locationManager.requestWhenInUseAuthorization()
        }
    }
    var lastLocation : CLLocationCoordinate2D!
    var addPinLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    
    // Action
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = "New Issue"
        annotation.coordinate = coordinate
        addPinLocation = coordinate
        mapView.addAnnotation(annotation)
        print("did add")
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    @objc func didClickAddIssue(button: UIButton){
        print("accessory add touched")
        performSegue(withIdentifier: "addIssue", sender: button)
    }
    
    @IBAction func onLocationPRess(_ sender: UIButton) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
    }
    
    
    @IBAction func onLongPressAdd(_ sender: UILongPressGestureRecognizer) {
        if UIGestureRecognizer.State.began == sender.state {
            for annotation in mapView.annotations {
                if annotation is MKPointAnnotation {
                    mapView.deselectAnnotation(annotation, animated: true)
                }
            }
        }
        
        if UIGestureRecognizer.State.ended == sender.state {
            let location = sender.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            self.addPin(coordinate: coordinate)
        }
    }
    
    
    // Delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title as? String{
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

        if let annotation = view.annotation {
            self.mapView.removeAnnotation(annotation)
        }
        print("deselect")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKPointAnnotation {
            let issueReuseId = "issueReuse"
            var issueAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: issueReuseId) as? MKPinAnnotationView
            if issueAnnotation == nil {
                issueAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: issueReuseId)
                issueAnnotation!.canShowCallout = true
                issueAnnotation!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
                
                // let leftCalloutImageView = issueAnnotation?.leftCalloutAccessoryView as! UIImageView
                // leftCalloutImageView.image = self.pickedImage
                let rightCalloutButton = UIButton(type: .contactAdd)
                rightCalloutButton.addTarget(self, action: #selector(didClickAddIssue(button:)), for: .touchUpInside)
                issueAnnotation?.rightCalloutAccessoryView = rightCalloutButton
            } else {
                issueAnnotation!.annotation = annotation
            }
           
            print("viewFor")
            return issueAnnotation
        } else {
            return annotation as? MKAnnotationView
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.pickedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
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

  

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationNavigationController = segue.destination as! UINavigationController
        let formViewController = destinationNavigationController.topViewController as! FormViewController
        
        let mapSnapshotImage = mapView.pbtakesnap()
        formViewController.mapSnapshotImage = mapSnapshotImage
        if let passedLocation = addPinLocation {
            formViewController.pinLocation = passedLocation
        } else {
            formViewController.pinLocation = lastLocation
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
