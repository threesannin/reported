//
//  EditProfileViewController.swift
//  Reported
//
//  Created by Daniel  Ochoa Aguila on 4/29/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var email: String!
    var firstName: String!
    var lastName: String!
    var userId: String!
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if firstName != ""{
            firstNameTextField.text = firstName
        }
        if lastName != "" {
            lastNameTextField.text = lastName
        }
        if email != "" {
            emailTextField.text = email
        }
        if urlString != "" {
            let url = URL(string: urlString)!
            imageView.af_setImage(withURL: url)
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
            if let imageData = imageView.image?.pngData() {
                let file = PFFileObject(data: imageData)
                profile["profileImage"] = file
            }

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
    
    @IBAction func changeProfileImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
//    @IBAction func onAddImage(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            picker.sourceType = .camera
//        } else {
//            picker.sourceType = .photoLibrary
//        }
//        present(picker, animated: true, completion: nil)
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
