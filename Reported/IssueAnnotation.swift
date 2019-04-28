//
//  IssueAnnotation.swift
//  Reported
//
//  Created by Sampson Liao on 4/27/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse
import MapKit

final class IssueAnnotation: NSObject, MKAnnotation {
    var descripText: String!
    var dirOfTravel: String!
    var followUp: Bool!
    var issueImageURL: URL?
    var issueDateTime: NSDate!
    var nearestCrossStreet: String! // can be geo
    var transMode: String!
    var location: PFGeoPoint
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(descripText: String!, dirOfTravel: String!, followUp: Bool!, issueCategory: String!, issueImageFile: PFFileObject?, issueDateTime: NSDate!, nearestCrossStreet: String!, transMode: String!, location: PFGeoPoint) {
        self.descripText = descripText
        self.dirOfTravel = dirOfTravel
        self.followUp = followUp
        // self.issueCategory = issueCategory
        self.issueDateTime = issueDateTime
        self.nearestCrossStreet = nearestCrossStreet
        self.transMode = transMode
        self.location = location
        self.title = issueCategory
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        super.init()
        if let urlString = issueImageFile?.url{
            let url = URL(string: urlString)!
            self.issueImageURL = url
        }
    }
}
