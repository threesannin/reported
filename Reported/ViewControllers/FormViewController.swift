//
//  FormViewController.swift
//  Reported
//
//  Created by Sampson Liao on 3/31/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import AlamofireImage
import UIKit
import iOSDropDown
import MapKit
import Parse

class FormViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryDropField: DropDown! {
        didSet {
            categoryDropField.optionArray = ["Roadway - Pothole", "Litter - Trash/Debris", "Graffiti", "Other"]
            categoryDropField.optionIds = [1,2,3,4]
            categoryDropField.didSelect {
                (selectedText , index ,id) in print("Selected String: \(selectedText) \n index: \(index)")
            }
        }
    }
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var directionDropField: DropDown! {
        didSet {
            directionDropField.optionArray = ["Northbound","Eastbound","Southbound","Westbound"]
            directionDropField.optionIds = [1,2,3,4]
            directionDropField.didSelect { (selectedText, index, id) in
                print("Selected String: \(selectedText) \n index: \(index)")
            }
        }
    }
    
    @IBOutlet weak var transportationLabel: UILabel!
    @IBOutlet weak var transportationDropField: DropDown! {
        didSet {
            transportationDropField.optionArray = ["Car","Bicycle","Walking","Other"]
            transportationDropField.didSelect { (selectedText, index, id) in
                print("Selected String: \(selectedText) \n index: \(index)")
            }
        }
    }
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    @IBOutlet weak var gpsLabel: UILabel! {
        didSet {
            if let lat = pinLocation?.latitude, let long = pinLocation?.longitude {
                gpsLabel.text = String("\(String(describing: lat)), \(String(describing: long))")
            }
        }
    }
    
    @IBOutlet weak var mapImageView: UIImageView! {
        didSet {
            if let mapImage = mapSnapshotImage {
                mapImageView.contentMode = UIView.ContentMode.scaleAspectFill
                mapImageView.image = mapImage
            }
        }
    }
    @IBOutlet weak var descriptionTextBox: UITextView!

    @IBOutlet weak var addImageButton: UIButton! {
        didSet {
            addImageButton.layer.borderWidth = 1
            addImageButton.layer.cornerRadius = 5
            addImageButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var followUpSwitch: UISwitch!
    
    var requiredFieldPairs: [UITextField : UILabel] = [:]
    var mapSnapshotImage: UIImage?
    var pinLocation: CLLocationCoordinate2D?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requiredFieldPairs[categoryDropField] = categoryLabel
        requiredFieldPairs[directionDropField] = directionLabel
        requiredFieldPairs[transportationDropField] = transportationLabel
        requiredFieldPairs[streetTextField] = streetLabel
        requiredFieldPairs[datePickerTextField] = dateTimeLabel
        
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerTextField.createModalPicker(datePicker: datePicker, selector: #selector(didSelectDate))
    }
    
    @objc func didSelectDate() {
        datePickerTextField.setFormat(picker: datePicker, controller: self)
    }
    
    
    @IBAction func onAddImage(_ sender: Any) {
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
        if let image = info[.editedImage] as? UIImage{
            let size = CGSize(width: 300, height: 300)
            let scaledImage = image.af_imageAspectScaled(toFill: size)
            
            imageView.image = scaledImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        // POST
        if requiredFieldsValid() {
            
            print("submitting")
            let post = PFObject(className: "Posts")
            
            post["category"] = categoryDropField.text
            post["dirOfTravel"] = directionDropField.text
            //post["ect"] = ect
            
            if let imageData = mapImageView.image?.pngData() {
                let file = PFFileObject(data: imageData)
                post["mapImage"] = file
            }
            
            if let imageData = imageView.image?.pngData() {
                let file = PFFileObject(data: imageData)
                post["issueImage"] = file
            }
            
            post["modeOfTrans"] = transportationDropField.text
            post["date"] = datePickerTextField.text
            post["time"] = datePickerTextField.text
            post["street"] = streetTextField.text
            post["latitude"] = pinLocation?.latitude
            post["longitude"] = pinLocation?.longitude
            post["description"] = "none"
            post["username"] = PFUser.current()!.username
            post["followUp"] = followUpSwitch.isOn

            post.saveInBackground{ (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    print("Saved!")
                } else {
                    print("error!")
                }
            }
            // POST
        } else {
            print("not all fields valid")
        }
        
    }
    
    func requiredFieldsValid() -> Bool {
        var flag = true
        
        for fieldpair in requiredFieldPairs {
            if (fieldpair.key.text?.isEmpty)! {
                fieldpair.value.markAsInvalid()
                fieldpair.key.blink()
                flag = false
            } else {
                fieldpair.value.markAsValid()
            }
        }
        return flag
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
extension UITextField {
    func createModalPicker(datePicker: UIDatePicker, selector: Selector) {
        self.inputView = datePicker
        let dpToolbar = UIToolbar()
        dpToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: selector)
        dpToolbar.setItems([doneButton], animated: true)
        self.inputAccessoryView = dpToolbar
    }
    
    @objc func setFormat(picker: UIDatePicker, controller: FormViewController) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        self.text = dateFormatter.string(from: picker.date)
        controller.view.endEditing(true)
    }
}
extension UILabel {
    func markAsInvalid(){
        self.textColor = UIColor.red
    }
    func markAsValid(){
        self.textColor = UIColor.black
    }
}
extension UIView{
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
}

