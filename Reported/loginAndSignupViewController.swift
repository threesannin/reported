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
            }
        }
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
