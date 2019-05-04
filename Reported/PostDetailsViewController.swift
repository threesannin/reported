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
    @IBOutlet weak var upvoteButton: UIButton!
    var isupvoted = false
    
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersLikedArray = post["usersLiked"] as? [String]
        let currentUser = PFUser.current()?.username as! String
        if(usersLikedArray == nil || !(usersLikedArray?.contains(currentUser))!){
            self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-100"), for: UIControl.State.normal)
            self.isupvoted = false
        }else{
            self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-filled-100"), for: UIControl.State.normal)
            self.isupvoted = true
        }
        
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
    
    @IBAction func upvote(_ sender: Any) {
        if(!isupvoted){
            let issue = PFObject(className: "Issues")
            issue.objectId = post.objectId
            issue["issueImage"] = post["issueImage"]
            issue["issueCategory"] = post["issueCategory"]
            issue["username"] = post["username"]
            issue["descripText"] = post["descripText"]
            issue["issueDateTime"] = post["issueDateTime"]
            issue["nearestCrossStreet"] = post["nearestCrossStreet"]
            issue["dirOfTravel"] = post["dirOfTravel"]
            issue["location"] = post["location"]
            issue["upVote"] = (post["upVote"] as! Int) + 1
            var usersLikedArray = post["usersLiked"] as? [String]
            if(usersLikedArray == nil){
                usersLikedArray = []
                usersLikedArray?.append((PFUser.current()?.username)!)
            }
            else{
                usersLikedArray?.append((PFUser.current()?.username)!)
            }
            issue["usersLiked"] = usersLikedArray
            issue.saveInBackground{ (success, error) in
                if success{
                    print("Updated")
                    self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-filled-100"), for: UIControl.State.normal)
                    self.isupvoted = true
                    let uvn = issue["upVote"] as! Int
                    self.upvoteLabel.text = String(uvn)
                    self.post = issue
                }else{
                    print("error")
                }
            } //
        }else{
            let issue = PFObject(className: "Issues")
            issue.objectId = post.objectId
            issue["issueImage"] = post["issueImage"]
            issue["issueCategory"] = post["issueCategory"]
            issue["username"] = post["username"]
            issue["descripText"] = post["descripText"]
            issue["issueDateTime"] = post["issueDateTime"]
            issue["nearestCrossStreet"] = post["nearestCrossStreet"]
            issue["dirOfTravel"] = post["dirOfTravel"]
            issue["location"] = post["location"]
            issue["upVote"] = (post["upVote"] as! Int) - 1
            var usersLikedArray = post["usersLiked"] as? [String]
            var count = 0
            for user in usersLikedArray!{
                if(user == PFUser.current()?.username){
                    usersLikedArray?.remove(at: count)
                }else{
                    count += 1
                }
            }
            issue["usersLiked"] = usersLikedArray
            issue.saveInBackground{ (success, error) in
                if success{
                    print("Updated")
                    self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-100"), for: UIControl.State.normal)
                    self.isupvoted = false
                    let uvn = issue["upVote"] as! Int
                    self.upvoteLabel.text = String(uvn)
                    self.post = issue
                }else{
                    print("error")
                }
            } //
            
        }
    }
    

}
