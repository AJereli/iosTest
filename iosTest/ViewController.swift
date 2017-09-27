//
//  ViewController.swift
//  iosTest
//
//  Created by User on 25/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!

    @IBOutlet weak var testTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func textFieldTDTest(_ sender: Any) {
        (sender as! UITextField).text?.append("t");
        
    }
    
}

