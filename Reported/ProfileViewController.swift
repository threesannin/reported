//
//  ProfileViewController.swift
//  Reported
//
//  Created by Daniel  Ochoa Aguila on 4/2/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    var profileData = [PFObject]()
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var query = PFQuery(className: "Issues")
        query.whereKey("username", equalTo: PFUser.current()?.username)
        query.limit = 20
    

        query.findObjectsInBackground{ (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
            }
        }

        query = PFQuery(className: "Profile")
        query.whereKey("username", equalTo: PFUser.current()?.username)
        query.limit = 1;
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil{
                self.profileData = posts!
                self.tableView.reloadData()
            } else{
                print("nothing")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(profileData.count == 0){
            return 0
        } else{
            //return 0
            return posts.count + 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            let post = profileData[0]
            let userName = post["username"] as! String
            let email = post["email"] as! String
            let firstName = post["firstName"] as! String
            let lastName = post["lastName"] as! String
            print(userName)
            //self.navBar.title = "this title"
            
            cell.email.text = email
            cell.firstName.text = firstName
            cell.lastName.text = lastName
            return cell
        } else {
            let post = posts[indexPath.row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell") as! AlertCell
            
            let reportType = post["issueCategory"] as! String
            let reportDesc = post["descripText"] as! String
            
            let finalString = "Issue Type: <" + reportType + "> Reported: '" + reportDesc + "'"
            
            cell.alertLabel.text = finalString
            
            let imageFile = post["issueImage"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.alertImage.af_setImage(withURL: url)
            
            return cell
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
         dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        print("logout")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("touche me")
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        
        let postDetailsViewController = segue.destination as! PostDetailsViewController
        postDetailsViewController.post = post
        
        tableView.deselectRow(at: indexPath, animated: true)
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
