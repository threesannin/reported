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
    
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoryLabel.text = post["issueCategory"] as? String
        usernameLabel.text = post["username"] as? String
        descriptionLabel.text = post["descripText"] as? String
        
        
        
        let dat = post["issueDateTime"] as? Date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        let dateString = dat.debugDescription
        if let date = dateFormatterGet.date(from: (dat?.description)!) {
            print(dateFormatterPrint.string(from: date))
        } else {
            print("There was an error decoding the string")
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
