//
//  SignUpViewController.swift
//  Reported
//
//  Created by Daniel  Ochoa Aguila on 4/1/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onButtonPress(_ sender: Any) {
        let user = PFUser()
        user.username = emailField.text
        user.password = passwordField.text
        user.signUpInBackground { (success, error) in
            if success {
//                UserDefaults.standard.set(true, forKey: "userLoggedIn")
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
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
