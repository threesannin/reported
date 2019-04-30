//
//  PostDetailsViewController.swift
//  Reported
//
//  Created by Jay Arellano on 4/17/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class PostDetailsViewController: UIViewController {
    

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var issueImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nearestCrossStreetLabel: UILabel!
    @IBOutlet weak var directionOfTravelLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var upvoteLabel: UILabel!
    
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = post["issueCategory"] as? String
        usernameLabel.text = post["username"] as? String
        descriptionLabel.text = post["descripText"] as? String
        let uvn = post["upVote"] as! Int
        upvoteLabel.text = String(uvn)
        
        
        let date = post["issueDateTime"] as? Date
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, YYYY h:mm a"
        let dateString = dateFormatterPrint.string(from: date!)
        dateLabel.text = dateString
        
        nearestCrossStreetLabel.text = post["nearestCrossStreet"] as? String
        directionOfTravelLabel.text = post["dirOfTravel"] as? String
        let location = post["location"] as! PFGeoPoint
        let locationString = "latitude: " + String(location.latitude) + " longitude: " + String(location.longitude)
        locationLabel.text = locationString
        let imageFile = post["issueImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        issueImage.af_setImage(withURL: url)
    }
    
    

}
