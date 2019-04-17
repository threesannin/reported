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

class FormViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Buttons
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIButton! {
        didSet {
            addImageButton.layer.borderWidth = 1
            addImageButton.layer.cornerRadius = 5
            addImageButton.layer.borderColor = #colorLiteral(red: 0.3481200933, green: 0.638322413, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var followUpSwitch: UISwitch!

    // Labels
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel! {
        didSet {
            if let lat = pinLocation?.latitude, let long = pinLocation?.longitude {
                gpsLabel.text = String("\(String(describing: lat)), \(String(describing: long))")
            }
        }
    }
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var transportationLabel: UILabel!
    
    // TextFields
    @IBOutlet weak var categoryDropField: DropDown! {
        didSet {
            categoryDropField.optionArray = ["Roadway - Pothole", "Litter - Trash/Debris", "Graffiti", "Other"]
            categoryDropField.optionIds = [1,2,3,4]
            categoryDropField.didSelect {
                (selectedText , index ,id) in print("Selected String: \(selectedText) \n index: \(index)")
            }
        }
    }
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            descriptionTextField.layer.borderWidth = 1
            descriptionTextField.layer.borderColor = #colorLiteral(red: 0.9136554599, green: 0.9137651324, blue: 0.9136180282, alpha: 1)
            descriptionTextField.layer.cornerRadius = 5
            
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: descriptionTextField.frame.height))
            descriptionTextField.leftView = leftPaddingView
            descriptionTextField.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var directionDropField: DropDown! {
        didSet {
            directionDropField.optionArray = ["Northbound","Eastbound","Southbound","Westbound"]
            directionDropField.optionIds = [1,2,3,4]
            directionDropField.didSelect { (selectedText, index, id) in
                print("Selected String: \(selectedText) \n index: \(index)")
            }
        }
    }
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var transportationDropField: DropDown! {
        didSet {
            transportationDropField.optionArray = ["Car","Bicycle","Walking","Other"]
            transportationDropField.didSelect { (selectedText, index, id) in
                print("Selected String: \(selectedText) \n index: \(index)")
            }
        }
    }
    
    // UIImageViews
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView! {
        didSet {
            if let mapImage = mapSnapshotImage {
                mapImageView.contentMode = UIView.ContentMode.scaleAspectFill
                mapImageView.image = mapImage
            }
        }
    }
    

    // Variables
    var requiredFieldPairs: [UITextField : UILabel] = [:]
    var issueDateTime: NSDate!
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
        requiredFieldPairs[descriptionTextField] = descriptionLabel
        
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerTextField.createModalPicker(datePicker: datePicker, selector: #selector(didSelectDate))
    }
    
    // Actions
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
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if requiredFieldsValid() {
            
            print("submitting")
            let post = PFObject(className: "Issues")
            post["issueCategory"] = categoryDropField.text
            post["dirOfTravel"] = directionDropField.text            
//            if let imageData = mapImageView.image?.pngData() {
//                let file = PFFileObject(data: imageData)
//                post["mapImage"] = file
//            }
            post["transMode"] = transportationDropField.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
            
            post["issueDateTime"] = dateFormatter.date(from: datePickerTextField.text!)
            
            post["nearestCrossStreet"] = streetTextField.text
            post["location"] = PFGeoPoint(latitude: pinLocation!.latitude, longitude: pinLocation!.longitude)
            if let imageData = imageView.image?.pngData() {
                let file = PFFileObject(data: imageData)
                post["issueImage"] = file
            }
            post["followUp"] = followUpSwitch.isOn
            // post["latitude"] = pinLocation?.latitude
            // post["longitude"] = pinLocation?.longitude
            post["descripText"] = descriptionTextField.text
            
            post["username"] = PFUser.current()!.username
            
            post.saveInBackground{ (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    print("Saved!")
                } else {
                    print("error!")
                }
            }
            // Send to Selenium
            
            
        } else {
            print("not all fields valid")
        }
        
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Delegate, helper
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            let size = CGSize(width: 300, height: 300)
            let scaledImage = image.af_imageAspectScaled(toFill: size)
            
            imageView.image = scaledImage
            
        }
        dismiss(animated: true, completion: nil)
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            print("The done button was not pressed, cancelling")
            return
        }
        print("prepare segue ok")
    }


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

