//
//  FormViewController.swift
//  Reported
//
//  Created by Sampson Liao on 3/31/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import iOSDropDown
import MapKit

class FormViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var categoryDropField: DropDown!
    @IBOutlet weak var directionDropField: DropDown!
    @IBOutlet weak var transportationDropField: DropDown!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    
    var mapSnapshotImage: UIImage?
    var pinLocation: CLLocationCoordinate2D?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.cornerRadius = 5
        addImageButton.layer.borderColor = UIColor.blue.cgColor
        
        if let mapImage = mapSnapshotImage {
            mapImageView.contentMode = UIView.ContentMode.scaleAspectFill
            mapImageView.image = mapImage
        }
        
        if let lat = pinLocation?.latitude, let long = pinLocation?.longitude {
            gpsLabel.text = String("\(String(describing: lat)), \(String(describing: long))")
        }
     
        categoryDropField.optionArray = ["Roadway - Pothole", "Litter - Trash/Debris", "Graffiti", "Other"]
//        //Its Id Values and its optional
        categoryDropField.optionIds = [1,2,3,4]
//        // The the Closure returns Selected Index and String
        categoryDropField.didSelect {
            (selectedText , index ,id) in print("Selected String: \(selectedText) \n index: \(index)")
        }
        
        directionDropField.optionArray = ["Northbound","Eastbound","Southbound","Westbound"]
        directionDropField.optionIds = [1,2,3,4]
        directionDropField.didSelect { (selectedText, index, id) in
            print("")
        }
        
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerTextField.createModalPicker(datePicker: datePicker, selector: #selector(didSelectDate))
    }
    
    @objc func didSelectDate() {
        datePickerTextField.setFormat(picker: datePicker, controller: self)
    }
    
    @IBAction func dismissDropDown(_ sender: UITapGestureRecognizer) {
        print("attempting dismissal")
        categoryDropField.resignFirstResponder()
        categoryDropField.hideList()
        directionDropField.resignFirstResponder()
        directionDropField.hideList()
        transportationDropField.resignFirstResponder()
        transportationDropField.hideList()
        streetTextField.resignFirstResponder()
        datePickerTextField.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        // POST
        print(categoryDropField.text!)
        if (directionDropField.text?.isEmpty)! {
            print("empty")
        }
        if let mot = transportationDropField.text {
            print(mot)
        }
        if let ncs = streetTextField.text {
            print(ncs)
        }
        if let datetime = datePickerTextField.text {
            print(datetime)
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

