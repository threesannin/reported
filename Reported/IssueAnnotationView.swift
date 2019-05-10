//
//  IssueAnnotationView.swift
//  Reported
//
//  Created by Sampson Liao on 5/4/19.
//  Copyright © 2019 threesannin. All rights reserved.
//
/*
 ["Roadway - Pothole", "Litter - Trash and Debris", "Graffiti", "Landscaping - Weeds, Trees, Brush", "Illegal Encampment"]
 
 */
import MapKit

class RoadwayAnnotationView: MKMarkerAnnotationView {
    static let ReuseID = "roadwayReuseID"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "roadway"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.red
        glyphImage = #imageLiteral(resourceName: "navigation")
    }
}

class GraffitiAnnotationView: MKMarkerAnnotationView {
    static let ReuseID = "graffitiReuseID"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "graffiti"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.orange
        glyphImage = #imageLiteral(resourceName: "spray")
    }
}

class LitterAnnotationView: MKMarkerAnnotationView {
    static let ReuseID = "litterReuseID"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "litter"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.brown
        glyphImage = #imageLiteral(resourceName: "garbage")
    }
}

class LandscapeAnnotationView: MKMarkerAnnotationView {
    static let ReuseID = "landscapeReuseID"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "landscape"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.green
        glyphImage = #imageLiteral(resourceName: "tree")
    }
}

class EncampAnnotationView: MKMarkerAnnotationView {
    static let ReuseID = "encampReuseID"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "encamp"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.blue
        glyphImage = #imageLiteral(resourceName: "camp")
    }
}


