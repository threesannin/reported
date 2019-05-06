//
//  IssueObj.swift
//  Reported
//
//  Created by Sampson Liao on 4/28/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import MapKit

final class IssueObj {
    var objectId: String!
    var user: String!
    var issueCategory: String!
    var dirOfTravel: String!
    var transMode: String!
    var issueDateTime: Date!
    var nearestCrossStreet: String!
    var issueLocation: CLLocationCoordinate2D!
    var upvoteCounter: Int!
    var issueImageURL: URL?
    
    init(objectId: String, user: String, issueCategory: String, dirOfTravel: String, transMode: String, issueDateTime: Date, nearestCrossStreet: String, issueLocation: CLLocationCoordinate2D, upvoteCounter: Int, issueImageURL: URL?) {
        self.user = user
        self.issueCategory = issueCategory
        self.dirOfTravel = dirOfTravel
        self.transMode = transMode
        self.issueDateTime = issueDateTime
        self.nearestCrossStreet = nearestCrossStreet
        self.issueLocation = issueLocation
        self.upvoteCounter = upvoteCounter
        self.issueImageURL = issueImageURL
    }
}
