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
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AutorizationUIViwController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AutorizationUIViwController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
   
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)

    }
    var actualKbHeight:CGFloat = 0.0
    var kbShow:Bool = false
    @objc func keyboardWillShow(_ notification: Notification) {
        if (kbShow){
            return
        }
        kbShow = true
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if actualKbHeight == 0.0{
                    actualKbHeight = keyboardSize.height
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.heightConstrain.constant -= self.actualKbHeight
                })
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        kbShow = false
        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstrain.constant += self.actualKbHeight
        })
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
