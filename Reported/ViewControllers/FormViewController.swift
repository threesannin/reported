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

class FormViewController: UIViewController {

    @IBOutlet weak var categoryDropField: DropDown!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var directionDropField: DropDown!
    @IBOutlet weak var transportationDropField: DropDown!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var timePickerTextField: UITextField!
    @IBOutlet weak var mapImageView: UIImageView!
    var mapSnapshotImage: UIImage?
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageButton.layer.borderWidth = 1
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
        
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        timePicker.datePickerMode = UIDatePicker.Mode.time
        createDatePicker()
        createTimePicker()
        // Do any additional setup after loading the view.
    }
    
    func createDatePicker() {
        datePickerTextField.inputView = datePicker
        let dpToolbar = UIToolbar()
        dpToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didSelectDate))
        dpToolbar.setItems([doneButton], animated: true)
        datePickerTextField.inputAccessoryView = dpToolbar
    }
    
    func createTimePicker() {
        timePickerTextField.inputView = timePicker
        
        let dpToolbar = UIToolbar()
        dpToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didSelectTime))
        dpToolbar.setItems([doneButton], animated: true)
        timePickerTextField.inputAccessoryView = dpToolbar
    }
    
    @objc func didSelectDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datePickerTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func didSelectTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        timePickerTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
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
