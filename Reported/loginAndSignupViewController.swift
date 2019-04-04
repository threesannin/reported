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
    @IBOutlet weak var signupPhoneNumberTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap(_ sender: Any) {
        print("tapping on main view")
        view.endEditing(true);
    }
    @IBAction func onTap2(_ sender: Any) {
        print("tapping on main view")
        view.endEditing(true);
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func onSignUp(_ sender: Any) {
        let profile = PFObject(className: "Profile")
        profile["username"] = signupUsernameTextfield.text!
        profile["firstName"] = signupFirstNameTextfield.text!
        profile["lastName"] = signupLastNameTextfield.text!
        profile["email"] = signupEmailTextfield.text!
        if(signupUsernameTextfield.text! == "" || signupFirstNameTextfield.text! == "" || signupLastNameTextfield.text! == "" || signupEmailTextfield.text! == "" || signupPasswordTextfield.text! == ""){
            //displaying an alert to screen
            let alert = UIAlertController(title: "Error Signing Up", message: "all fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            profile.saveInBackground{ (success, error) in
                if success{
                    print("saved")
                }else{
                    print("error")
                }
            }
            
            let user = PFUser()
            user.username = signupUsernameTextfield.text!
            user.password = signupPasswordTextfield.text!
            user.email = signupEmailTextfield.text!
            user.signUpInBackground { (success, error) in
                if success{
                    self.performSegue(withIdentifier: "loginSegue2", sender: nil)
                }else {
                    print("error signing up: \(error?.localizedDescription)")
                }
            }
        }
        
    }
    
}
