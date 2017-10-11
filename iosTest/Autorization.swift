//
//  Autorization.swift
//  iosTest
//
//  Created by User on 02/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import PromiseKit


class Autorization {
  
    private let login:String
    private let password:String
    init(login:String, password:String) {
        self.login = login
        self.password = password
        
    }
    
   
    
    func jsonFromFile(folder: String, fileName:String) -> [String: Any]? {
        let textFromFile:String? = WorkWithFile(folder: "Users", fileName: "user\(login)").readTextFromFile()
        if textFromFile != nil {
            let jsonData:Any? = textFromFile!.parseJSONString
            return  jsonData as? [String: Any]
        }
        return nil
    }
    
    func autorization() -> Promise<Bool>{
        return Promise { fulfill, reject in
            
            if let parsedJsonData = jsonFromFile(folder: "Users", fileName: "user\(login)"){
                if (password.sha256() == parsedJsonData["password"] as! String){
                    print("Autorization done")
                    Sources.getSources().user = User(userName: login, userPassword: password.sha256(), favoriteSources: parsedJsonData["sources"] as! [String])
                    Sources.getSources().setAllSelections(sourcesLinks: parsedJsonData["sources"] as! [String])
                    fulfill(true)
                }else{
                    fulfill(false)
                }
                
            }else {
                fulfill(false)
                
            }
        }
    }
    
    
    func registration() -> Promise<Bool> {
        

        return Promise { fulfill, reject in
            print("---REGISTRATION START---")
            let fileWorker = WorkWithFile(folder: "Users", fileName: "user\(login)")
            if fileWorker.fileExists(){
                
                let stringJson:String = """
                {"login": "\(login)",
                "password": "\(password.sha256())",
                "sources": []
                }
                """
                
                if fileWorker.writeTextToFile(text: stringJson){
                    fulfill(true)
                    print("String writed to file \n \(stringJson)\n")
                }
                
                print("---REGISTRATION END---")
            }else{
                fulfill(false)
            }
        }
        
    }
}
    
