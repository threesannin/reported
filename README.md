Reported - README
===

# Reported

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Report issues dealing with city/state infustructure damage/disturbances which includes Graffiti, Litter, Roadway(Potholes, Roadkill), Landscaping, etc. This app uses current geo-location to report issues along with a short easy to fill survey. This information will be sent to the appropriate city/state reporting outlet (email, online form, etc). 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Reporting
- **Mobile:** iOS
- **Story:** 
- **Market:** Anyone
- **Habit:** 
- **Scope:** California

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register a new account
* User can login
* User can submit issues 
* User can view submissions
* User can upvote/downvote issues
* User can view their profile recent reports

**Optional Nice-to-have Stories**

* User can report issues outside of California
* User can view city information (email, phone, people to contact)
* Users can add optional photos to issue
* User can received notification of local issues

### 2. Screen Archetypes

* Login
    * User can login
* Register
    * User can register a new account
* Map
    * User can submit issues
* Submission form
    * User can submit issues
* View Reports
    * User can view submissions
    * User can upvote/downvote issues
* Profile
* ...

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map
* Profile
* Alerts

**Flow Navigation** (Screen to Screen)

* Login 
    * Map
* Register
    * Map
* Map
   * Submission form
   * Alerts page
* Profile
   * Profile page
   * Submission history
* Alerts
    * Alerts page

## Wireframes
<img src="https://i.imgur.com/yrR4CNq.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

### Models
#### Post
|Property|Type|Description|
|---|---|---|
|issueCategory|string|type of issue to be reported|
|dirOfTravel|string|direction defined by Northbound, Southbound, Eastbound, Westbound|
|transMode|string|type of transportation like car, boat, walking, etc  |
|nearestCrossStreet|string|nearest intersection to issue|
|dateTime|Date|time issue was created|
|image|File|image related to issue|
|location|GeoPoint|coordinate of issue|
|descripText|string|description of issue|
|followUp|boolean|whether or not follow up response is needed|
|upVote|number|number of upvotes|
|username|string|author of post|


#### User
|Property|Type|Description|
|---|---|---|
|username|string|unique user identifier|
|email|string|user email|
|firstName|string|user first name|
|lastName|string|user last name|
|password|string|user password|

### Networking
## List of network requests by screen
- Login 
    - (Read/Get) Query user credentials to get corresponding user
     ``` swift
     PFUser.logInWithUsername(inBackground: username, password: password)
            { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    ```
- SignUp
    - (Create/Post) Create a new user
    ``` swift
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    ```
- Create a Report
    - (Create/Post) Create a new report
    ``` swift
        let post = PFObject(className: "Posts")
        
        post["category"] = categoryField.text
        post["dirOfTravel"] = dirOfTravelField.text
        //post["ect"] = ect
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)

        post["image"] = file
        
        post.saveInBackground{ (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("error!")
            }
        }
    ```
- Get reports
    - (Read/Get)
    ``` swift
        let query = PFQuery(className:"Posts")
        //query.includeKeys(["author", "comments", "comments.author"])
        
        query.limit = amount
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    ```
- Get Profile
    - (Read/Get)
    ``` swift
        let query = PFQuery(className:"User")
        //query.includeKeys(["author", "comments", "comments.author"])
        
        query.limit = amount
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    ```
 - Selenium
     - Body structure
     ``` swift
         
      Form: Codable
      var issueCategory: String
      var dirOfTravel: String
      var transMode: String
      var nearestCrossStreet: String
      var dateTime: String
      var latitude: String
      var longitude: String
      var descripText: String
      var name: String
      var email: String
      var phone: String
      var followUp: Bool
    ```
    - APi CAll
    ``` swift
        @IBAction func postApiCall(_ sender: Any) {
        
        let url = URL(string: "http://localhost:8089/submitPost")
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        //let post = Response(status: "daniel sampson", error: false)
        let post = Form() // create your own form
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            //print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print(error.localizedDescription)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let msg = try! JSONSerialization.jsonObject(with: data, options:[]) as! [String: Any]
                print(msg)

                print(msg["status"] as! String)
            }
        }
        task.resume()
        
    }
    ```
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
