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
    
   
    
   
    func autorization() -> Promise<Bool>{
        return Promise { fulfill, reject in
            
            if let parsedJsonData =  WorkWithFile(folder: "Users", fileName: "user\(login)").jsonFromFile() as? [String:Any]{
                if (password.sha256() == parsedJsonData["password"] as! String){
                    print("Autorization done")
                    Sources.getInstance().user = User(userName: login, userPassword: password.sha256(), favoriteSources: parsedJsonData["sources"] as! [String])
                    Sources.getInstance().setAllSelections(sourcesLinks: parsedJsonData["sources"] as! [String])
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
                    //print("String writed to file \n \(stringJson)\n")
                }
                
                print("---REGISTRATION DONE---")
            }else{
                fulfill(false)
            }
        }
        
    }
}
    
