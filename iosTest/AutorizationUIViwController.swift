//
//  AutorizationUIViwController.swift
//  iosTest
//
//  Created by User on 02/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import PromiseKit

class AutorizationUIViwController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)

    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)

    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
      
        if (!aRect.contains(contentView!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(contentView!.frame, animated: true)
            }
        
    }
    var activeField: UITextField?

    func textFieldDidBeginEditing(textField: UITextField!)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        activeField = nil
    }
    private func startItemsView (){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    @IBAction func clickLoginButton(_ sender: Any) {
        let login:String = loginTextField.text!
        let password:String = passwordTextField.text!
        
        if login.count > 3 && password.count > 3 {
           
            firstly{ () -> Promise<Bool> in
                activityIndicator.startAnimating()
                let autorization:Autorization = Autorization (login: login, password: password)
                return autorization.autorization()
            }
            .then{isAuth -> Void  in
                if isAuth{
                  self.startItemsView()
                }
                else{
                    self.infoLabel.text = "Wrong login or pass"
                }
                
                }.always {
                    self.activityIndicator.stopAnimating()
            }

        }
        else {
            infoLabel.text = "Login or password too short"
        }
    }
    
    @IBAction func clickRegistrationButton(_ sender: Any) {
        let login:String = loginTextField.text!
        let password:String = passwordTextField.text!
        
        if login.count > 3 && password.count > 3 {
            firstly{ () -> Promise<Bool> in
                activityIndicator.startAnimating()
                let user:Autorization = Autorization(login: login, password: password)
                return user.registration()
                }.then{res -> () in
                    if res {
                        self.infoLabel.text = "Registration is done"
                        
                    }
            }.always {
                    self.activityIndicator.stopAnimating()
            }
            
        }
        else {
            infoLabel.text = "Login or password too short"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
