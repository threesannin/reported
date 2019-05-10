//
//  AlertViewController.swift
//  Reported
//
//  Created by Jay Arellano on 4/2/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class AlertViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var alertsTableView: UITableView!
    var posts = [PFObject]()
    var selectedPost: PFObject!
    var currentLocation: PFGeoPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertsTableView.dataSource = self
        alertsTableView.delegate = self
        alertsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PFGeoPoint.geoPointForCurrentLocation{
            (geoPoint, error) in
            if error == nil {
                self.currentLocation = geoPoint
                print("alerts page currentLocation: ", self.currentLocation)
                let query = PFQuery(className: "Issues")
                query.whereKey("location", nearGeoPoint:self.currentLocation, withinMiles: 40.0)
                query.limit = 15
                query.findObjectsInBackground{ (posts, error) in
                    if posts != nil{
                        self.posts = posts!
                        self.alertsTableView.reloadData()
                    }
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = alertsTableView.dequeueReusableCell(withIdentifier: "AlertCell") as! AlertCell
        
        let reportType = post["issueCategory"] as! String
        let reportDesc = post["descripText"] as! String
        
        let finalString = "Issue Type: <" + reportType + "> Reported: '" + reportDesc + "'"
        
        cell.alertLabel.text = finalString
        
        if let imageFile = post["issueImage"] as? PFFileObject{
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.alertImage.af_setImage(withURL: url)
        }else{
            let urlString = "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg"
            let url = URL(string: urlString)!
            cell.alertImage.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = alertsTableView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        

        let destinationNavigationController = segue.destination as! UINavigationController
        let postDetailsViewController = destinationNavigationController.topViewController as! PostDetailsViewController
        
        
        
        
        postDetailsViewController.post = post
        
        alertsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindToAlert(segue:UIStoryboardSegue) {
        alertsTableView.reloadData()
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
