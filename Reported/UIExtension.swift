//
//  UIExtension.swift
//  Reported
//
//  Created by Sampson Liao on 4/21/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import DropDown

extension UIView{
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
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

extension UIButton {

}

extension UITextField {
    
}

extension DropDown {
    func setDefault(textField: UITextField, data: [String]){
        self.anchorView = textField
        self.dataSource = data
        self.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            textField.text = item
        }
        self.bottomOffset = CGPoint(x: 0, y:(self.anchorView?.plainView.bounds.height)!)
        self.topOffset = CGPoint(x: 0, y:-(self.anchorView?.plainView.bounds.height)!)
        self.dismissMode = .automatic
        self.shadowOffset=CGSize(width:0 , height: 4)
        self.shadowRadius=3
    }
}
