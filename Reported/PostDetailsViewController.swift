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
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var showInMapsButton: UIButton!
    var isupvoted = false
    var isdownvoted = false
    let downvoteThreshold = -5
    
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersLikedArray = post["usersLiked"] as? [String] //getting the users that liked the post
        let usersDislikedArray = post["usersDisliked"] as? [String] //getting the users that disliked the post
        let currentUser = PFUser.current()?.username as! String
        //checking is user has already liked post
        if(usersLikedArray == nil || !(usersLikedArray?.contains(currentUser))!){
            self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-100"), for: UIControl.State.normal)
            self.isupvoted = false
        }else{
            self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-filled-100"), for: UIControl.State.normal)
            self.isupvoted = true
        }
        //checking is user has already disliked post
        if(usersDislikedArray == nil || !(usersDislikedArray?.contains(currentUser))!){
            self.downvoteButton.setImage(UIImage(named: "icons8-unlike-100"), for: UIControl.State.normal)
            self.isdownvoted = false
        }else{
            self.downvoteButton.setImage(UIImage(named: "icons8-unlike-filled-100"), for: UIControl.State.normal)
            self.isdownvoted = true
        }
        
        categoryLabel.text = post["issueCategory"] as? String
        usernameLabel.text = post["username"] as? String
        descriptionLabel.text = post["descripText"] as? String
        let uvn = post["upVote"] as! Int
        upvoteLabel.text = String(uvn)
        //formating the date object
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
            var usersDislikedArray = post["usersDisliked"] as? [String]
            //adding user to liked array
            if(usersLikedArray == nil){
                usersLikedArray = []
                usersLikedArray?.append((PFUser.current()?.username)!)
            }
            else{
                usersLikedArray?.append((PFUser.current()?.username)!)
            }
            //removing user from dislike array if they have already disliked
            var count = 0
            if(usersDislikedArray != nil){
                for user in usersDislikedArray!{
                    if(user == PFUser.current()?.username){
                        usersDislikedArray?.remove(at: count)
                        issue["upVote"] = (post["upVote"] as! Int) + 2
                    }else{
                        count += 1
                    }
                }
            }
            
            issue["usersLiked"] = usersLikedArray
            issue["usersDisliked"] = usersDislikedArray
            issue.saveInBackground{ (success, error) in
                if success{
                    print("Updated")
                    self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-filled-100"), for: UIControl.State.normal)
                    self.downvoteButton.setImage(UIImage(named: "icons8-unlike-100"), for: UIControl.State.normal)
                    self.isupvoted = true
                    self.isdownvoted = false
                    let uvn = issue["upVote"] as! Int
                    self.upvoteLabel.text = String(uvn)
                    self.post = issue
                }else{
                    print("error")
                }
            } // done updating post
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
            issue["usersDisliked"] = post["usersDisliked"] as! [String]
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
            } // done updating post
        }
    }
    @IBAction func downvote(_ sender: Any) {
        if(!isdownvoted){
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
            var usersDislikedArray = post["usersDisliked"] as? [String]
            var usersLikedArray = post["usersLiked"] as? [String]
            if(usersDislikedArray == nil){
                usersDislikedArray = []
                usersDislikedArray?.append((PFUser.current()?.username)!)
            }
            else{
                usersDislikedArray?.append((PFUser.current()?.username)!)
            }
            //removing user from liked array if they have already liked
            var count = 0
            if(usersLikedArray != nil){
                for user in usersLikedArray!{
                    if(user == PFUser.current()?.username){
                        usersLikedArray?.remove(at: count)
                        issue["upVote"] = (post["upVote"] as! Int) - 2
                    }else{
                        count += 1
                    }
                }
            }
            
            issue["usersDisliked"] = usersDislikedArray
            issue["usersLiked"] = usersLikedArray
            let uvn = issue["upVote"] as! Int
            if(uvn == self.downvoteThreshold){
                do{
                    try issue.delete()
                    //performSegue(withIdentifier: "unwindToAlertSegue", sender: self) //commented out until daniel finishes it
                    return
                }
                catch{
                    print("error")
                }
                
            }
            issue.saveInBackground{ (success, error) in
                if success{
                    print("Updated")
                    self.downvoteButton.setImage(UIImage(named: "icons8-unlike-filled-100"), for: UIControl.State.normal)
                    self.upvoteButton.setImage(UIImage(named: "icons8-good-quality-100"), for: UIControl.State.normal)
                    self.isupvoted = false
                    self.isdownvoted = true
                    let uvn = issue["upVote"] as! Int
                    self.upvoteLabel.text = String(uvn)
                    self.post = issue
                }else{
                    print("error")
                }
            } // done updating post
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
            issue["upVote"] = (post["upVote"] as! Int) + 1
            var usersDislikedArray = post["usersDisliked"] as? [String]
            issue["usersLiked"] = post["usersLiked"] as? [String]
            var count = 0
            for user in usersDislikedArray!{
                if(user == PFUser.current()?.username){
                    usersDislikedArray?.remove(at: count)
                }else{
                    count += 1
                }
            }
            issue["usersDisliked"] = usersDislikedArray
            issue.saveInBackground{ (success, error) in
                if success{
                    print("Updated")
                    self.downvoteButton.setImage(UIImage(named: "icons8-unlike-100"), for: UIControl.State.normal)
                    self.isdownvoted = false
                    let uvn = issue["upVote"] as! Int
                    self.upvoteLabel.text = String(uvn)
                    self.post = issue
                }else{
                    print("error")
                }
            } // done updating post
        }
    }
    @IBAction func showInMaps(_ sender: Any) { // empty for sampson ;)
        //sampsons code here
    }
    
    
}
