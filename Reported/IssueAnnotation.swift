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

final class IssueAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
//    var issue: IssueObj!
    var issue: PFObject!
    
    init(issue: PFObject, issueCategory: String, coordinate: CLLocationCoordinate2D) {
        self.issue = issue
        self.title = issueCategory
        self.coordinate = coordinate
        super.init()
    }
}
