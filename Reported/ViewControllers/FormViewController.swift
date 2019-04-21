//
//  FormViewController.swift
//  Reported
//
//  Created by Sampson Liao on 3/31/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import AlamofireImage
import UIKit
import MapKit
import Parse
import DropDown

final class FormObj: Codable {
    var issueCategory: String
    var dirOfTravel: String
    var transMode: String
    var nearestCrossStreet: String
    var dateTime: String
    var latitude: String
    var longitude: String
    var descripText: String
    var name: String
    var email: String
    var phone: String
    var followUp: Bool
    
    init(issueCategory: String!, dirOfTravel: String!, transMode: String!, nearestCrossStreet: String!, dateTime: String!, latitude: String!, longitude: String!, descripText: String!, name: String!, email: String!, phone: String!, followUp: Bool!) {
        self.issueCategory = issueCategory
        self.dirOfTravel = dirOfTravel
        self.transMode = transMode
        self.nearestCrossStreet = nearestCrossStreet
        self.dateTime = dateTime
        self.latitude = latitude
        self.longitude = longitude
        self.descripText = descripText
        self.name = name
        self.email = email
        self.phone = phone
        self.followUp = followUp
    }
}

struct Form: Codable {
    var issueCategory: String
    var dirOfTravel: String
    var transMode: String
    var nearestCrossStreet: String
    var dateTime: String
    var latitude: Double
    var longitude: Double
    var descripText: String
    var name: String
    var email: String
    var phone: String
    var followUp: Bool
    
    init(issueCategory: String!, dirOfTravel: String!, transMode: String!, nearestCrossStreet: String!, dateTime: String!, latitude: Double!, longitude: Double!, descripText: String!, name: String!, email: String!, phone: String!, followUp: Bool!) {
        self.issueCategory = issueCategory
        self.dirOfTravel = dirOfTravel
        self.transMode = transMode
        self.nearestCrossStreet = nearestCrossStreet
        self.dateTime = dateTime
        self.latitude = latitude
        self.longitude = longitude
        self.descripText = descripText
        self.name = name
        self.email = email
        self.phone = phone
        self.followUp = followUp
    }
}

class FormViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Buttons
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIButton! {
        didSet {
//            addImageButton.layer.borderWidth = 1
//            addImageButton.layer.cornerRadius = 5
//            addImageButton.layer.borderColor = #colorLiteral(red: 0.3481200933, green: 0.638322413, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var followUpSwitch: UISwitch!

    // Labels
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descripLabel: UILabel!
    @IBOutlet weak var dirLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel! {
        didSet {
            if let lat = pinLocation?.latitude, let long = pinLocation?.longitude {
                gpsLabel.text = String("\(String(describing: lat)), \(String(describing: long))")
            }
        }
    }
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var transLabel: UILabel!
    
    // TextFields
    @IBOutlet weak var issueTextField: FormTextField! {
        didSet {
            //[
            
        }
    }
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var descipTextField: UITextField! {
        didSet {
//            descipTextField.layer.borderWidth = 1
//            descipTextField.layer.borderColor = #colorLiteral(red: 0.9136554599, green: 0.9137651324, blue: 0.9136180282, alpha: 1)
//            descipTextField.layer.cornerRadius = 5
            
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: descipTextField.frame.height))
            descipTextField.leftView = leftPaddingView
            descipTextField.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var dirTextField: FormTextField! {
        didSet {
           // ["Northbound","Eastbound","Southbound","Westbound", "Both"]
            
        }
    }
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var transTextField: FormTextField! {
        didSet {
            // ["Car","Bicycle","Walking","Other"]
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
    
    let issueDropDown = DropDown()
    let dirDropDown = DropDown()
    let transDropDown = DropDown()
    
    // Variables
    var requiredFieldPairs: [UITextField : UILabel] = [:]
    var issueDateTime: NSDate!
    var mapSnapshotImage: UIImage?
    var pinLocation: CLLocationCoordinate2D?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueTextField.delegate = self
        dirTextField.delegate = self
        transTextField.delegate = self
        
        issueTextField.dropDown.setDefault(textField: issueTextField, data: ["Roadway - Pothole", "Litter - Trash and Debris", "Graffiti", "Landscaping - Weeds, Trees, Brush", "Illegal Encampment"])
        
        dirTextField.dropDown.setDefault(textField: dirTextField, data: ["Northbound","Eastbound","Southbound","Westbound", "Both"])
        
        transTextField.dropDown.setDefault(textField: transTextField, data: ["Car","Bicycle","Walking","Other"])
        

        
//        issueDropDown.setDefault(textField: issueTextField, data: ["Roadway - Pothole", "Litter - Trash and Debris", "Graffiti", "Landscaping - Weeds, Trees, Brush", "Illegal Encampment"])
//
//        dirDropDown.setDefault(textField: dirTextField, data: ["Northbound","Eastbound","Southbound","Westbound", "Both"])
//
//        transDropDown.setDefault(textField: transTextField, data: ["Car","Bicycle","Walking","Other"])
//
//        fieldMenuPair[issueTextField] = issueDropDown
//        fieldMenuPair[dirTextField] = dirDropDown
//        fieldMenuPair[transTextField] = transDropDown
//
        requiredFieldPairs[issueTextField] = issueLabel
        requiredFieldPairs[dirTextField] = dirLabel
        requiredFieldPairs[transTextField] = transLabel
        requiredFieldPairs[streetTextField] = streetLabel
        requiredFieldPairs[datePickerTextField] = dateTimeLabel
        requiredFieldPairs[descipTextField] = descripLabel
        
        
        
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerTextField.createModalPicker(datePicker: datePicker, selector: #selector(didSelectDate))
    }
    
    // Actions
    @IBAction func onDropSearch(_ sender: FormTextField) {
        if let found = sender.dropDown.dataSource.firstIndex(where: {
            $0.contains(sender.text!)
        }){
            sender.dropDown.selectRow(found)
            //topTextField.text = dropDown.selectedItem
        } else {
            if let index = sender.dropDown.indexForSelectedRow {
                sender.dropDown.deselectRow(at: index)
            }
        }
        
        
    }
    @IBAction func onDropEditBegin(_ sender: FormTextField) {
        sender.dropDown.show()
    }
    
    @IBAction func tappedOut(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onDropEditingEnd(_ sender: FormTextField) {
        if let found = sender.dropDown.dataSource.firstIndex(where: {
            $0.contains(sender.text!)
        }){
            sender.dropDown.selectRow(found)
            sender.text = sender.dropDown.selectedItem
            //topTextField.text = dropDown.selectedItem
        } else {
            sender.text = nil
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField is FormTextField {
            onDropEditingEnd(textField as! FormTextField)
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func touchTextField(_ sender: FormTextField) {
        sender.dropDown.show()
//        if let dropDown = fieldMenuPair[sender] {
//            dropDown.show()
//        }
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
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if requiredFieldsValid() {
            print("submitting")
            
            // Form Codable
            let form = Form(issueCategory: issueTextField.text!, dirOfTravel: dirTextField.text!, transMode: transTextField.text!, nearestCrossStreet: streetTextField.text!, dateTime: datePickerTextField.text!, latitude: pinLocation!.latitude, longitude: pinLocation!.longitude, descripText: descipTextField.text!, name: "test", email: "email", phone: "phone", followUp: followUpSwitch.isOn)
            
            // Send to Parse
            postParse(form: form)
            
            // Send to Selenium
            postSelenium(form: form)
            
            
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
    
    
    func postParse(form : Form) {
        let post = PFObject(className: "Issues")
        post["issueCategory"] = form.issueCategory
        post["dirOfTravel"] = form.dirOfTravel
        post["transMode"] = form.transMode
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm:ss a"
        post["issueDateTime"] = dateFormatter.date(from: form.dateTime)
        
        post["nearestCrossStreet"] = form.nearestCrossStreet
        post["location"] = PFGeoPoint(latitude: form.latitude, longitude: form.longitude)
        
        if let imageData = imageView.image?.pngData() {
            let file = PFFileObject(data: imageData)
            post["issueImage"] = file
        }
        post["followUp"] = form.followUp
        post["descripText"] = form.descripText
        post["username"] = PFUser.current()!.username
        
        post.saveInBackground{ (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("error!")
            }
        }
    }
    
    func postSelenium(form: Form) {
        let url = URL(string: "http://localhost:8089/submitPost")
        // Specify this request as being a POST method
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        //let post = Response(status: "daniel sampson", error: false)
         // create your own form
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(form)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            //print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print(error.localizedDescription)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let msg = try! JSONSerialization.jsonObject(with: data, options:[]) as! [String: Any]
                print(msg)
                
                print(msg["status"] as! String)
            }
        }
        task.resume()
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
//extension UILabel {
//    func markAsInvalid(){
//        self.textColor = UIColor.red
//    }
//    func markAsValid(){
//        self.textColor = UIColor.black
//    }
//}
//extension UIView{
//    func blink() {
//        self.alpha = 0.2
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
//    }
//}
//extension DropDown {
//    func setDefault(textField: UITextField, data: [String]){
//        self.anchorView = textField
//        self.dataSource = data
//        self.selectionAction = { (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
//            textField.text = item
//        }
//        self.bottomOffset = CGPoint(x: 0, y:(self.anchorView?.plainView.bounds.height)!)
//        self.topOffset = CGPoint(x: 0, y:-(self.anchorView?.plainView.bounds.height)!)
//        self.dismissMode = .automatic
//        self.shadowOffset=CGSize(width:0 , height: 4)
//        self.shadowRadius=3
//        self.cornerRadius=1
//    }
//}


