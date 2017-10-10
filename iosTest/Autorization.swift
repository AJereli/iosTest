//
//  Autorization.swift
//  iosTest
//
//  Created by User on 02/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation







class Autorization {
  
    private let login:String
    private let password:String
    init(login:String, password:String) {
        self.login = login
        self.password = password
        
    }
    
    private func writeTextToFile(fileName:String, text:String){
        let folder = "Users"
       
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileName + ".txt")
        do {
           
            try text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("error with file")
            
        }
        do {
            let text2 = try String(contentsOf: file, encoding: .utf8)
            print("FROM FILE: \(text2)")

        }
        catch {
        }
   }
    
    
    func autorization() -> Bool{
        let jsonData:Any? =  WorkWithFile(folder: "Users", fileName: "user\(login)").readTextFromFile()!.parseJSONString

      
        let parsedJsonData = jsonData as! [String: Any]
        if (password.sha256() == parsedJsonData["password"] as! String){
            print("Autorization done")
            Sources.getSources().user = User(userName: login, userPassword: password.sha256(), favoriteSources: parsedJsonData["sources"] as! [String])
            Sources.getSources().setAllSelections(sourcesLinks: parsedJsonData["sources"] as! [String])
            return true
        }else{
            return false
        }
        
    }
    func registration(){
        print("---REGISTRATION START---")
        
        let stringJson:String = """
        {"login": "\(login)",
        "password": "\(password.sha256())",
        "sources": []
        }
        """
      
      
        if WorkWithFile(folder: "Users", fileName: "user\(login)").writeTextToFile(text: stringJson){
            print("String writed to file \n \(stringJson)\n")
        }
        
        
        let jsonData = stringJson.parseJSONString
        if jsonData == nil{
            print("jsonData nil")
        }else{
            print("jsonData valid")
        }
        
        print("---REGISTRATION END---")
    }
    
    
    
    
}

