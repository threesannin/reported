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
    var mapSnapshotImage: UIImage?
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

    @IBOutlet weak var addImageButton: UIButton!
    
    typealias selectorHandler = ()  -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.cornerRadius = 5
        
        addImageButton.layer.borderColor = UIColor.blue.cgColor
        
        if let mapImage = mapSnapshotImage {
            mapImageView.contentMode = UIView.ContentMode.scaleAspectFill
            mapImageView.image = mapImage
        }

        categoryDropField.optionArray = ["Option 1", "Option 2", "Option 3", "Option 4"]
//        //Its Id Values and its optional
        categoryDropField.optionIds = [1,2,3,4]
//        // The the Closure returns Selected Index and String
        categoryDropField.didSelect {
            (selectedText , index ,id) in print("Selected String: \(selectedText) \n index: \(index)")
        }
        
        directionDropField.optionArray = ["Northbound","Eastbound","Southbound","Westbound"]
//
        directionDropField.optionIds = [1,2,3,4]
        directionDropField.didSelect { (selectedText, index, id) in
            print("")
        }
        
        
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerTextField.createModalPicker(datePicker: datePicker, selector: #selector(didSelectDate))
        // timePickerTextField.createModalPicker(datePicker: timePicker, selector: #selector(didSelectTime))
        // Do any additional setup after loading the view.
    }
    
    @objc func didSelectDate() {
        datePickerTextField.setFormat(picker: datePicker, controller: self)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
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

