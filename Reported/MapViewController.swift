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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    //    var currentMapSnapShotImage: UIImage?
    
    var pickedImage: UIImage?
    
    var locationManager : CLLocationManager!
    var lastLocation : CLLocationCoordinate2D!
    var addPinLocation: CLLocationCoordinate2D!
    
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
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
        annotation.title = "New Issue"
        annotation.coordinate = coordinate
        addPinLocation = coordinate
        mapView.addAnnotation(annotation)
        print("did add")
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)

    }
    
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
//                let vc = UIImagePickerController()
//                vc.delegate = self
//                vc.allowsEditing = true
//
//                if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                    print("Camera is available 📸")
//                    vc.sourceType = .camera
//                } else {
//                    print("Camera 🚫 available so we will use photo library instead")
//                    vc.sourceType = .photoLibrary
//                }
//                self.present(vc, animated: true, completion: nil)
                
                issueAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: issueReuseId)
                issueAnnotation!.canShowCallout = true
                issueAnnotation!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
                
//                let leftCalloutImageView = issueAnnotation?.leftCalloutAccessoryView as! UIImageView
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
    
    @objc func didClickAddIssue(button: UIButton){
        print("accessory add touched")
        performSegue(withIdentifier: "addIssue", sender: button)
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
