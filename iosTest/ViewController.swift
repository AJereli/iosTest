//
//  ViewController.swift
//  iosTest
//
//  Created by User on 25/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldTDTest(_ sender: Any) {
        (sender as! UITextField).text?.append("t");
        
    }
    
}

