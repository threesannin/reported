//
//  ClusterAnnotationView.swift
//  Reported
//
//  Created by Sampson Liao on 5/4/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: CustomCluster
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            _ = cluster.memberAnnotations.count
//            if count(issueType: .roadway) > 0 {
//                displayPriority = .defaultLow
//            } else {
//                displayPriority = .defaultHigh
//            }
        }
    }
    

   
    
    private func count(issueType type: IssueAnnotation.IssueType) -> Int {
        guard let cluster = annotation as? MKClusterAnnotation else {
            return 0
        }
        
        return cluster.memberAnnotations.filter { member -> Bool in
            guard let issue = member as? IssueAnnotation else {
                fatalError("Found unexpected annotation type")
            }
            return issue.type == type
            }.count
    }
}

