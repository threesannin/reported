//
//  IssueAnnotation.swift
//  Reported
//
//  Created by Sampson Liao on 4/27/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import MapKit
import Parse
/*
 ["Roadway - Pothole", "Litter - Trash and Debris", "Graffiti", "Landscaping - Weeds, Trees, Brush", "Illegal Encampment"]
 
 */
final class IssueAnnotation: NSObject, MKAnnotation {
    enum IssueType: String, Decodable {
        case roadway = "Roadway - Pothole"
        case graffiti = "Graffiti"
        case litter = "Litter - Trash and Debris"
        case encamp = "Illegal Encampment"
        case landscape = "Landscaping - Weeds, Trees, Brush"
    }
    
    var type: IssueType = .roadway
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            // For most uses, `coordinate` can be a standard property declaration without the customized getter and setter shown here.
            // The custom getter and setter are needed in this case because of how it loads data from the `Decodable` protocol.
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    var title: String!
    var issue: PFObject!
    
    init(issue: PFObject) {
        self.issue = issue
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: (self.issue["location"] as! PFGeoPoint).latitude, longitude: (self.issue["location"] as! PFGeoPoint).longitude)
        self.title = self.issue["issueCategory"] as? String
    }
    
   
    
    
}

