//
//  ViewController.swift
//  Reported
//
//  Created by Daniel  Ochoa Aguila on 3/27/19.
//  Copyright © 2019 Daniel  Ochoa Aguila. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        INPreferences.requestSiriAuthorization { (status) in
        INVocabulary.shared().setVocabularyStrings(["push up", "sit up", "pull up"], of: .workoutActivityName) //some concerns here
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

