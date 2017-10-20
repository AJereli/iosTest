//
//  ViewController.swift
//  iosTest
//
//  Created by User on 25/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import WebKit
class PageViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView!
    
    var siteUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swiperight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swiperight.direction = .right
        
        self.view!.addGestureRecognizer(swiperight)
        
        let url = URL(string: siteUrl!)
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
    }
    
    @objc private func swipeRight(gestureRecognizer: UISwipeGestureRecognizer) {
        let autorizationUIViwController: AutorizationUIViwController = AutorizationUIViwController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(autorizationUIViwController, animated: true)
        
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
    
    
}

