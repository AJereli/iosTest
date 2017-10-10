//
//  AutorizationUIViwController.swift
//  iosTest
//
//  Created by User on 02/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class AutorizationUIViwController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func clickLoginButton(_ sender: Any) {
        let login:String = loginTextField.text!
        let password:String = passwordTextField.text!
        
        if login.count > 3 && password.count > 3 {
            
            let autorization:Autorization = Autorization (login: login, password: password)
            
            if autorization.autorization(){
           
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }else{
                infoLabel.text = "Wrong login or pass"
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
    
   
    @IBAction func clickRegistrationButton(_ sender: Any) {
        let login:String = loginTextField.text!
        let password:String = passwordTextField.text!
        if login.count > 3 && password.count > 3 {
            let user:Autorization = Autorization (login: login, password: password)
            user.registration()
        }
        else {
            infoLabel.text = "Login or password too short"
        }
    }
    @IBOutlet weak var registrationButton: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
