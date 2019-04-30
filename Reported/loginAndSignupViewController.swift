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
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
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
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
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
    
}
