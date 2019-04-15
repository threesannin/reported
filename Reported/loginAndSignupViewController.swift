//
//  loginAndSignupViewController.swift
//  Reported
//
//  Created by Jay Arellano on 4/2/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse

class loginAndSignupViewController: UIViewController {

    @IBOutlet weak var loginUsernameTextfield: UITextField!
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    @IBOutlet weak var signupFirstNameTextfield: UITextField!
    @IBOutlet weak var signupLastNameTextfield: UITextField!
    @IBOutlet weak var signupEmailTextfield: UITextField!
    @IBOutlet weak var signupUsernameTextfield: UITextField!
    @IBOutlet weak var signupPasswordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //end editing on sign up view
    @IBAction func onTap(_ sender: Any) {
        print("tapping on main view")
        view.endEditing(true);
    }
    //end editing on login view
    @IBAction func onTap2(_ sender: Any) {
        print("tapping on main view")
        view.endEditing(true);
    }
    //dissmissing the sign up modal after pressing back to login
    @IBAction func dismissModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //actions for when login is pressed
    @IBAction func onLogin(_ sender: Any) {
        let user = loginUsernameTextfield.text!
        let pass = loginPasswordTextfield.text!
        
        PFUser.logInWithUsername(inBackground: user, password: pass) {
            (user, error)in
            if user != nil {
                // Do stuff after successful login.
                print("login successful")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                // The login failed. Check error to see why.
                print("Error: \(String(describing: error?.localizedDescription))")
                
                //displaying an alert to screen
                let alert = UIAlertController(title: "Error Logging In", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    //actions for when sign up is pressed.
    @IBAction func onSignUp(_ sender: Any) {
        //creating a 'Profile' object to save to the database
        let profile = PFObject(className: "Profile")
        profile["username"] = signupUsernameTextfield.text!
        profile["firstName"] = signupFirstNameTextfield.text!
        profile["lastName"] = signupLastNameTextfield.text!
        profile["email"] = signupEmailTextfield.text!
        
        //only save user to database if all text fields are filled out
        if(signupUsernameTextfield.text! == "" || signupFirstNameTextfield.text! == "" ||
           signupLastNameTextfield.text! == "" || signupEmailTextfield.text! == "" ||
           signupPasswordTextfield.text! == ""){ //error if all fields are not filled
            
            //displaying an alert to screen
            let alert = UIAlertController(title: "Error Signing Up", message: "all fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }else{ //if all fields are filled save user
            //creating a PFUser object to save the user with only their username, password, and email
            let user = PFUser()
            user.username = signupUsernameTextfield.text!
            user.password = signupPasswordTextfield.text!
            user.email = signupEmailTextfield.text!
            user.signUpInBackground { (success, error) in
                if success{
                    profile.saveInBackground{ (success, error) in
                        if success{
                            print("saved")
                        }else{
                            print("error")
                        }
                    }
                    self.performSegue(withIdentifier: "loginSegue2", sender: nil)
                }else {
                    print("error signing up: \(String(describing: error?.localizedDescription))")
                }
            }
            
        }
        
    }
    
    
    
    @IBAction func apiCaller(_ sender: Any) {
        print("pressed")
        let url = URL(string: "https://reportedapi.herokuapp.com/test")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
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

    
    struct Form: Codable {
        let category: String
        let dirOfTravel: String
        let modeOfTrans: String
        let crossStreet: String
        let date: String
        let time: String
        let latitude: String
        let longitude: String
        let description: String
        let username: String
        let receiveResponse: Bool
    }
    
    @IBAction func postApiCall(_ sender: Any) {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "http"
//        urlComponents.host = "localhost:8089"
//        urlComponents.path = "/seleniumTest"
//        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        let url = URL(string: "http://localhost:8089/seleniumTest")
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        //let post = Response(status: "daniel sampson", error: false)
        let post = Form(category: "Pothole", dirOfTravel: "South", modeOfTrans: "Car", crossStreet: "fist and second", date: "04/09/2019", time: "14:50", latitude: "12.431.1", longitude: "12.43.1", description: "big pothole", username: "potholeFinder", receiveResponse: false)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            //request.httpBody = jsonData
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
    
}
