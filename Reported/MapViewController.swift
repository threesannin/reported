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
import Parse
import AlamofireImage

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
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
    var centerLocation: CLLocationCoordinate2D!
    var addPinLocation: CLLocationCoordinate2D!
    var issues = [PFObject]()
    var selectedIssue : PFObject!
    //    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        //        self.refreshController.addTarget(self, action: #selector(loadIssues), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        refreshData()
    }
    
    // Action
    func createNewIssueAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = "New Issue"
        annotation.coordinate = coordinate
        addPinLocation = coordinate
        mapView.addAnnotation(annotation)
        print("did add")
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func createIssueAnnotation() {
        var annotations: [IssueAnnotation] = []
        print("number of issues: \(issues.count)")
        for issue in self.issues {
            print("createIssueAnnotation")
            let annotation = IssueAnnotation(
                descripText: issue["descripText"] as? String, dirOfTravel: issue["dirOfTravel"] as? String, followUp: issue["followUp"] as? Bool, issueCategory: issue["issueCategory"] as? String, issueImageFile: issue["issueImage"] as? PFFileObject, issueDateTime: issue["issueDateTime"] as? NSDate, nearestCrossStreet: issue["nearestCrossStreet"] as? String, transMode: issue["transMode"] as? String, location: issue["location"] as! PFGeoPoint
            )
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    @objc func clearIssueAnnotations() {
        mapView.removeAnnotations(mapView.annotations.filter {$0 is IssueAnnotation})
    }
    
    @objc func refreshData() {
        // temp link to filter button
        clearIssueAnnotations()
        loadIssues()
        
    }
    
    @objc func didClickAddIssue(button: UIButton){
        print("accessory add touched")
        performSegue(withIdentifier: "addIssue", sender: button)
    }
    
    @objc func didClickIssueDetail(button: UIButton) {
        print("accessory detail touched")
    }
    
    @objc func loadIssues() {
        let numberOfIssues = 20
        
        let centerGeoPoint = PFGeoPoint(latitude: centerLocation.latitude, longitude: centerLocation.longitude)
        let query = PFQuery(className: "Issues")
        query.includeKeys(["transMode", "issueDateTime", "descripText", "location", "issueCategory", "dirOfTravel", "nearestCrossStreet", "image"])
        query.whereKey("location", nearGeoPoint:centerGeoPoint, withinKilometers: mapView.currentRadius())
        query.limit = numberOfIssues
        query.findObjectsInBackground { (issues, error) in
            if issues != nil {
                self.issues = issues!
                self.createIssueAnnotation()
            }
        }
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
            self.createNewIssueAnnotation(coordinate: coordinate)
        }
    }
    
    @IBAction func onLocationPRess(_ sender: UIButton) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
    }
    
    @IBAction func onTapRefresh(_ sender: Any) {
        refreshData()
    }
    
    @IBAction func onLongPressRefresh(_ sender: UILongPressGestureRecognizer) {
        if UIGestureRecognizer.State.ended == sender.state {
            print("clear annotations")
            clearIssueAnnotations()
        }
        
    }
    
    // Map Delegates
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title as? String{
                print("Tapped \(String(describing: title)) pin")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // get annotations in area
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
        lastLocation = userLocation.coordinate
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation, !(annotation is IssueAnnotation) {
            self.mapView.removeAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerLocation = mapView.centerCoordinate
        print("changed region: \(centerLocation.latitude), \(centerLocation.longitude)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is IssueAnnotation {
            print("viewFor Issue Annotation")
            let reportReuse = "reportReuse"
            var issueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reportReuse) as? MKPinAnnotationView
            if issueAnnotationView == nil {
                issueAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reportReuse)
                issueAnnotationView!.canShowCallout = true
                if let url = (annotation as!
                    IssueAnnotation).issueImageURL {
                    issueAnnotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))

                    let leftCalloutImageView = issueAnnotationView?.leftCalloutAccessoryView as! UIImageView
                    leftCalloutImageView.af_setImage(withURL: url)
                      issueAnnotationView?.leftCalloutAccessoryView = leftCalloutImageView
                    print("valid image")
                } else {
                    print("invalid image")
                }
                let rightCalloutButton = UIButton(type: .detailDisclosure)
                rightCalloutButton.addTarget(self, action: #selector(didClickIssueDetail(button:)), for: .touchUpInside)
                issueAnnotationView?.rightCalloutAccessoryView = rightCalloutButton
            } else {
                issueAnnotationView!.annotation = annotation
            }
            return issueAnnotationView
        } else if annotation is MKPointAnnotation {
            print("is not IssueAnnotation")
            let newIssueReuse = "newIssueReuse"
            var newIssueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: newIssueReuse) as? MKPinAnnotationView
            if newIssueAnnotationView == nil {
                newIssueAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: newIssueReuse)
                newIssueAnnotationView!.canShowCallout = true
                newIssueAnnotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 25, height:25))
                 let leftCalloutImageView = newIssueAnnotationView?.leftCalloutAccessoryView as! UIImageView
                 leftCalloutImageView.image = #imageLiteral(resourceName: "danger")
                leftCalloutImageView.contentMode = UIView.ContentMode.scaleAspectFit
                let rightCalloutButton = UIButton(type: .contactAdd)
                rightCalloutButton.addTarget(self, action: #selector(didClickAddIssue(button:)), for: .touchUpInside)
                newIssueAnnotationView?.rightCalloutAccessoryView = rightCalloutButton
            } else {
                newIssueAnnotationView!.annotation = annotation
            }
            return newIssueAnnotationView
        } else {
            return annotation as? MKAnnotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    // Allow updates to location when moving
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    // get last location when location is updated
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.first as? CLLocation
        lastLocation = location?.coordinate
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.pickedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
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
extension MKMapView {
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
    
}
