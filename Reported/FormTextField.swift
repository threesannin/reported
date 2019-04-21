//
//  FormTextField.swift
//  Reported
//
//  Created by Sampson Liao on 4/21/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit
import DropDown
class FormTextField: UITextField, UITextFieldDelegate {
    
    lazy var dropDown : DropDown = {
        let dropDown = DropDown()
        return dropDown
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

