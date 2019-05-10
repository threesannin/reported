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
    @IBOutlet weak var issueTextField: FormTextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var descipTextField: UITextField! {
        didSet {
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: descipTextField.frame.height))
            descipTextField.leftView = leftPaddingView
            descipTextField.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var dirTextField: FormTextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var transTextField: FormTextField!
    let issueDropDown = DropDown()
    let dirDropDown = DropDown()
    let transDropDown = DropDown()
    
    // Buttons
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var followUpSwitch: UISwitch!

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
        issueTextField.delegate = self
        dirTextField.delegate = self
        transTextField.delegate = self
        
        
        lookUpCurrentLocation { (placemark) in
            
            if let thoroughfare = placemark?.thoroughfare, let subThoroughfare = placemark?.subThoroughfare {
                self.streetTextField.text = "\(subThoroughfare) \(thoroughfare)"
            }
        }
        
        
        issueTextField.dropDown.setDefault(textField: issueTextField, data: ["Roadway - Pothole", "Litter - Trash and Debris", "Graffiti", "Landscaping - Weeds, Trees, Brush", "Illegal Encampment"])
        
        dirTextField.dropDown.setDefault(textField: dirTextField, data: ["Northbound","Eastbound","Southbound","Westbound", "Both"])
        
        transTextField.dropDown.setDefault(textField: transTextField, data: ["Car","Bicycle","Walking","Other"])
        
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
    
    @IBAction func onDropEditingEnd(_ sender: FormTextField) {
        if let found = sender.dropDown.dataSource.firstIndex(where: {
            $0.contains(sender.text!)
        }){
            sender.dropDown.selectRow(found)
            sender.text = sender.dropDown.selectedItem
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
    
    @IBAction func done(_ sender: UIButton) {
        if requiredFieldsValid() {
            print("submitting")
            
            // Form Codable
            let form = Form(issueCategory: issueTextField.text!, dirOfTravel: dirTextField.text!, transMode: transTextField.text!, nearestCrossStreet: streetTextField.text!, dateTime: datePickerTextField.text!, latitude: pinLocation!.latitude, longitude: pinLocation!.longitude, descripText: descipTextField.text!, name: PFUser.current()?.username, email: PFUser.current()?.email, phone: "9056869456", followUp: followUpSwitch.isOn)
        
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
    
    @IBAction func tappedOut(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onTapMap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "updateLocSegue", sender: Any?.self)
    }
    
    @IBAction func unwindToForm(segue:UIStoryboardSegue) {
        if let lat = pinLocation?.latitude, let long = pinLocation?.longitude {
            gpsLabel.text = String("\(String(describing: lat)), \(String(describing: long))")
        }
        mapImageView.image = mapSnapshotImage
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
        post["upVote"] = 1
        
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
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = pinLocation {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude),
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    print(error.debugDescription)
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            print("no last location")
            completionHandler(nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
//        guard let button = sender as? UIBarButtonItem, button === doneButton else {
//            print("The done button was not pressed, cancelling")
//            return
//        }
        if segue.identifier == "updateLocSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let updateMapViewController = destinationNavigationController.topViewController as! UpdateMapViewController
            
            updateMapViewController.receivedLocation = pinLocation
            
        }
    }
}
