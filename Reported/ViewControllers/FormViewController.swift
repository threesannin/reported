//
//  FormViewController.swift
//  Reported
//
//  Created by Sampson Liao on 3/31/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import iOSDropDown

class FormViewController: UIViewController {

    @IBOutlet weak var categoryDropField: DropDown!
    
    @IBOutlet weak var datePickerTextField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDropField.optionArray = ["Option 1", "Option 2", "Option 3", "Option 4"]
        //Its Id Values and its optional
        categoryDropField.optionIds = [1,2,3,4]
        // The the Closure returns Selected Index and String
        categoryDropField.didSelect {
            (selectedText , index ,id) in print("Selected String: \(selectedText) \n index: \(index)")
        }
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    
    func createDatePicker() {
        datePickerTextField.inputView = datePicker
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
