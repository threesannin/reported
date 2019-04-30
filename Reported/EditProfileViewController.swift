//
//  EditProfileViewController.swift
//  Reported
//
//  Created by Daniel  Ochoa Aguila on 4/29/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var email: String!
    var firstName: String!
    var lastName: String!
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if firstName != nil{
            firstNameTextField.text = firstName
        }
        if lastName != nil {
            lastNameTextField.text = lastName
        }
        if email != nil {
            emailTextField.text = email
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func update(_ sender: Any) {
        
        if(firstNameTextField.text! == "" || lastNameTextField.text! == ""
            || emailTextField.text! == ""){ //error if any fields are not filled
            //displaying an alert to screen
            let alert = UIAlertController(title: "Error Updating Profile", message: "all fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
        
            let profile = PFObject(className: "Profile")
            profile.objectId = userId
            profile["username"] = PFUser.current()?.username
            profile["firstName"] = firstNameTextField.text!
            profile["lastName"] = lastNameTextField.text!
            profile["email"] = emailTextField.text!

            profile.saveInBackground{ (success, error) in
                if success{
                    print("Updated")
                }else{
                    print("error")
                }
            } //
        } // else
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
