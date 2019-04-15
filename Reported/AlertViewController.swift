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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertsTableView.dataSource = self
        alertsTableView.delegate = self
        alertsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Post")
        query.limit = 20
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.alertsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = alertsTableView.dequeueReusableCell(withIdentifier: "AlertCell") as! AlertCell
        
        let reportType = post["category"] as! String
        let reportDesc = post["description"] as! String
        
        let finalString = "new " + reportType + " Reported: '" + reportDesc + "'"
        
        cell.alertLabel.text = finalString
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.alertImage.af_setImage(withURL: url)
        
        return cell
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
