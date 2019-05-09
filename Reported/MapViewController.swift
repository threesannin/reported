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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {
    
    
   
   
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapSearchBar: UISearchBar! {
        didSet{
            
//           mapSearchBar.searchBarStyle = UISearchBar.Style.minimal
            mapSearchBar.borderWidth = 1
            mapSearchBar.borderColor = UIColor.clear
            mapSearchBar.cornerRadius = 17
            
//            mapSearchBar.layer.cornerRadius = 5
            
//            let textFieldInsideSearchBar = mapSearchBar.value(forKey: “searchField”) as? UITextField
//            textFieldInsideSearchBar?.textColor = UIColor.white
            
           
//            mapSearchBar.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    
    @IBOutlet weak var toolBarView: UIView!
    
    @IBOutlet weak var filterMenuButton: UIButton!
    @IBOutlet weak var refreshMenuButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var filterMenuView1: UIView!
    @IBOutlet weak var filterMenuView2: UIView!
    
    @IBOutlet weak var searchTypeSegment: UISegmentedControl!
    @IBOutlet weak var searchRadiusSegment: UISegmentedControl!
    
    
    var refreshMenuButtonCenter: CGPoint!
    var refreshButtonDestCenter: CGPoint!
    var clearButtonDestCenter: CGPoint!
    
    var filterMenuView1Center: CGPoint!
    var filterMenuView2Center: CGPoint!
    var refreshMenuOpen = false
    var filterMenuOpen = false
    
    var meterRadius: Int!

    var pickedImage: UIImage?
    var locationManager : CLLocationManager! {
        didSet {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 5
            
            locationManager.requestWhenInUseAuthorization()
        }
    }
    var lastLocation : CLLocationCoordinate2D!
    var centerLocation: CLLocationCoordinate2D!
    var addPinLocation: CLLocationCoordinate2D!
    var issues = [PFObject]()
    var selectedIssue : PFObject?
    var allWaitGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapSearchBar.delegate = self
        mapView.register(MKClusterAnnotation.self, forAnnotationViewWithReuseIdentifier: "cluster")
        mapView.register(RoadwayAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(GraffitiAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(LitterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(EncampAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(LandscapeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        refreshButtonDestCenter = refreshButton.center
        clearButtonDestCenter = clearButton.center
        
        refreshButton.center = refreshMenuButton.center
        clearButton.center = refreshMenuButton.center
        
        filterMenuView1.center = toolBarView.center
        filterMenuView2.center = toolBarView.center
        toolBarView.center = toolBarView.center

        print("center is: \(refreshMenuButton.center.x), \(refreshMenuButton.center.y)")
        
        print("center is: \(refreshButton.center.x), \(refreshButton.center.y)")
        print("center is: \(clearButton.center.x), \(clearButton.center.y)")
       refreshMenuOpen = false
        filterMenuOpen = false
        
        filterMenuView1.cornerRadius = 10
        filterMenuView2.cornerRadius = 10
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAllIssues()
    }

    func notifyRefresh(group: DispatchGroup){
        group.notify(queue: .main) {
            self.refreshAnnotations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Action
    func createNewIssueAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = "New Issue"
        annotation.coordinate = coordinate
//        addPinLocation = coordinate
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func createIssueAnnotation() {
        var annotations: [IssueAnnotation] = []
        for issue in self.issues {
            let annotation = IssueAnnotation(issue: issue)
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(annotations, animated: true)
    }
    
    @objc func clearIssueAnnotations() {
        mapView.removeAnnotations(mapView.annotations.filter {$0 is IssueAnnotation})
    }
    
    @objc func refreshAnnotations() {
        // temp link to filter button
        clearIssueAnnotations()
        createIssueAnnotation()
    }
    
    @objc func didClickAddIssue(button: UIButton){
        performSegue(withIdentifier: "addIssue", sender: button)
        
    }
    
    @objc func didTapAnnoDetail(button: UIButton) {
        performSegue(withIdentifier: "tapDetail", sender: button)
    }
    
    @objc func getAllIssues() {
        let numberOfIssues = 100
//        let waitGroup = DispatchGroup()
        let centerGeoPoint = PFGeoPoint(latitude: centerLocation.latitude, longitude: centerLocation.longitude)
        let query = PFQuery(className: "Issues")
        query.includeKeys(["transMode", "issueDateTime", "descripText", "location", "issueCategory", "dirOfTravel", "nearestCrossStreet", "image"])
        query.whereKey("location", nearGeoPoint:centerGeoPoint, withinKilometers: mapView.currentRadius())
        query.limit = numberOfIssues
        allWaitGroup.enter()
        query.findObjectsInBackground { (issues, error) in
            if issues != nil {
                self.issues = issues!
                self.allWaitGroup.leave()
//                self.createIssueAnnotation()
            }
        }
        notifyRefresh(group: allWaitGroup)
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
            addPinLocation = coordinate
           
            self.createNewIssueAnnotation(coordinate: coordinate)
            
        }
    }
    
    func convertToRadius(_ segment : Int!) -> Int {
        switch segment {
        case 0:
            return 500
        case 1:
            return 1000
        case 2:
            return 1500
        default:
            break
        }
        return 500
    }
    
    @IBAction func onLocationPRess(_ sender: UIButton) {
//        let annotations = [mapView.userLocation]
        let radius = convertToRadius(searchRadiusSegment!.selectedSegmentIndex)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: CLLocationDistance(exactly:
radius)!, longitudinalMeters: CLLocationDistance(exactly: radius)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
//        mapView.showAnnotations(annotations, animated: true)
        hideFilterMenu()
        hideRefreshMenu()
    }
    
    
    @IBAction func onPressFilterMenu(_ sender: UIButton) {
       toggleFilterMenu()
        hideRefreshMenu()
    }
    

    func toggleFilterMenu() {
        if filterMenuOpen {
            hideFilterMenu()
        } else {
            showFilterMenu()
        }
    }
    

    func showRefreshMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.refreshButton.center = self.refreshButtonDestCenter
            self.clearButton.center = self.clearButtonDestCenter
        })
        refreshMenuOpen = true
    }
    
    @IBAction func hideRefreshMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.refreshButton.center = self.refreshMenuButton.center
            self.clearButton.center = self.refreshMenuButton.center
        })
        refreshMenuOpen = false
    }
    
    func showFilterMenu() {
        let drop1 = (toolBarView.frame.height / 2) + (filterMenuView1.frame.height / 2)
        let drop2 = (toolBarView.frame.height / 2) + (3 * filterMenuView1.frame.height / 2)
        UIView.animate(withDuration: 0.3, animations: {
            self.filterMenuView1.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: drop1)
            self.filterMenuView2.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: drop2)
        })
        UIView.animate(withDuration: 0.09, animations: {
            self.toolBarView.cornerRadius = 0
            self.toolBarView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            self.filterMenuView1.cornerRadius = 0
            self.filterMenuView2.cornerRadius = 0
            self.filterMenuView2.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        })
        filterMenuOpen = true
    }
    
    @IBAction func hideFilterMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.filterMenuView1.transform = CGAffineTransform.identity
            self.filterMenuView2.transform = CGAffineTransform.identity
            self.toolBarView.cornerRadius = 10
            self.filterMenuView1.cornerRadius = 10
            self.filterMenuView2.cornerRadius = 10
        })
        filterMenuOpen = false
    }
    
    func toggleRefreshMenu() {
        print("refresh menu tapped")
        
        if refreshMenuOpen {
            hideRefreshMenu()
        } else {
            showRefreshMenu()
        }
    }
    @IBAction func onTapRefreshMenu(_ sender: UIButton) {
       toggleRefreshMenu()
        hideFilterMenu()
    }
    @IBAction func onTapRefresh(_ sender: Any) {
        refreshAnnotations()
    }
    

    @IBAction func onTapMap(_ sender: UITapGestureRecognizer) {
        if refreshMenuOpen {
            hideRefreshMenu()
        }
        if filterMenuOpen {
            hideFilterMenu()
        }
        
    }
    
    @IBAction func onTapClearAnno(_ sender: UIButton) {
        clearIssueAnnotations()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
//            search(keyword: keyword)
            print("searching real places")
            switch searchTypeSegment.selectedSegmentIndex {
            case 0:
                search(keyword: keyword)
            case 1:
                searchLocal(keyword)
            default:
                break
            }
    }
    
    func searchLocal(_ text: String) {
        guard let mapView = mapView else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            let searchCoord = response.mapItems.first?.placemark.coordinate
            self.createNewIssueAnnotation(coordinate: searchCoord!)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func search(keyword: String){
        if keyword.isEmpty {
            getAllIssues()
        } else {
            getSearchIssues(keyword: keyword)
        }
    }
    
    @objc func getSearchIssues(keyword: String) {
        let query = PFQuery(className: "Issues")
          let centerGeoPoint = PFGeoPoint(latitude: centerLocation.latitude, longitude: centerLocation.longitude)
        query.whereKey("issueCategory", matchesText: keyword.trimmingCharacters(in: [" "]))
        query.whereKey("issueCategory",nearGeoPoint:centerGeoPoint, withinKilometers: mapView.currentRadius())
        allWaitGroup.enter()
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // The request failed
                print(error.localizedDescription)
            } else if let objects = objects {
                self.issues = objects
                self.allWaitGroup.leave()

            }
        }
        notifyRefresh(group: allWaitGroup)
    }
    
    // Map Delegates
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let issueAnnotation = view.annotation {
            if issueAnnotation is IssueAnnotation{
                selectedIssue = (issueAnnotation as! IssueAnnotation).issue
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // get annotations in area
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let clusterAnnotation = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        return clusterAnnotation
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
        addPinLocation = nil
        selectedIssue = nil
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        centerLocation = mapView.centerCoordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is IssueAnnotation {
            var issueAnnotationView: MKMarkerAnnotationView
            let title = (annotation as! IssueAnnotation).title!
                
//            print("TITLE IS: \(annotation.title)")
//            if annotation.title! == "Roadway - Pothole" {
//                issueAnnotationView = RoadwayAnnotationView(annotation: annotation, reuseIdentifier: RoadwayAnnotationView.ReuseID)
//            } else if annotation.title! == "Litter - Trash and Debris" {
//                issueAnnotationView = LitterAnnotationView(annotation: annotation, reuseIdentifier: LitterAnnotationView.ReuseID)
//            } else if annotation.title! == "Landscaping - Weeds, Trees, Brush" {
//                 issueAnnotationView = LandscapeAnnotationView(annotation: annotation, reuseIdentifier: LandscapeAnnotationView.ReuseID)
//            } else if annotation.title! == "Illegal Encampment" {
//                issueAnnotationView = EncampAnnotationView(annotation: annotation, reuseIdentifier: EncampAnnotationView.ReuseID)
//            } else {
//                fatalError("Found unexpected issue category")
//
//            }
            switch title {
            case "Roadway - Pothole":
                issueAnnotationView = RoadwayAnnotationView(annotation: annotation, reuseIdentifier: RoadwayAnnotationView.ReuseID)
            case "Graffiti":
                issueAnnotationView = GraffitiAnnotationView(annotation: annotation, reuseIdentifier: GraffitiAnnotationView.ReuseID)
            case "Litter - Trash and Debris":
                issueAnnotationView = LitterAnnotationView(annotation: annotation, reuseIdentifier: LitterAnnotationView.ReuseID)
            case "Landscaping - Weeds, Trees, Brush":
                issueAnnotationView = LandscapeAnnotationView(annotation: annotation, reuseIdentifier: LandscapeAnnotationView.ReuseID)
            case "Illegal Encampment":
                issueAnnotationView = EncampAnnotationView(annotation: annotation, reuseIdentifier: EncampAnnotationView.ReuseID)
            default:
                fatalError("Found unexpected issue category")
            }
            issueAnnotationView.clusteringIdentifier = "cluster"
            issueAnnotationView.canShowCallout = true
                if let issueImageFileObj = (annotation as! IssueAnnotation).issue["issueImage"] {
                    if let urlString = (issueImageFileObj as! PFFileObject).url{
                        let url = URL(string: urlString)!
                        issueAnnotationView.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
                        let leftCalloutImageView = issueAnnotationView.leftCalloutAccessoryView as! UIImageView
                        leftCalloutImageView.af_setImage(withURL: url)
                        issueAnnotationView.leftCalloutAccessoryView = leftCalloutImageView
                    }
                } else {
                    print("invalid image")
                }
                let rightCalloutButton = UIButton(type: .detailDisclosure)
                rightCalloutButton.addTarget(self, action: #selector(didTapAnnoDetail(button:)), for: .touchUpInside)
            issueAnnotationView.rightCalloutAccessoryView = rightCalloutButton
//            } else {
//                issueAnnotationView!.annotation = annotation
//            }
            return issueAnnotationView
        } else if annotation is MKPointAnnotation {
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
        if segue.identifier == "addIssue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let formViewController = destinationNavigationController.topViewController as! FormViewController
            
            let mapSnapshotImage = mapView.pbtakesnap()
            formViewController.mapSnapshotImage = mapSnapshotImage
            if let passedLocation = addPinLocation {
                formViewController.pinLocation = passedLocation
            } else {
                formViewController.pinLocation = lastLocation
            }
        } else if segue.identifier == "tapDetail" {
            
            let postDetailsViewController = segue.destination as! PostDetailsViewController

          
            self.navigationController?.isNavigationBarHidden = false
            if let selectedIssue = self.selectedIssue {
                postDetailsViewController.post = selectedIssue
            }
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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
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

