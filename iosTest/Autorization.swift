//
//  Autorization.swift
//  iosTest
//
//  Created by User on 02/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation


extension String {
    
    var parseJSONString: Any? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if data != nil {
            var json:Any?
            
            do {
                try json = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            }
            catch  {
                
                return json
            }
            return json
        } else {
            return nil
        }
    }
}


extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
}

class User {
    enum UserAction {
        case authorization
        case registration
    }
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
        let jsonData:Any?
        jsonData =  WorkWithFile(folder: "Users", fileName: "user\(login)").readTextFromFile()!.parseJSONString
        
        
        let parsedJsonData = jsonData as! [String: Any]
        if (password.sha256() == parsedJsonData["password"] as! String){
            print("Autorization done")
            return true
        }else{
            return false
        }
        
    }
    func registration(){
        print("---REGISTRATION START---")
        
        let stringJson:String = """
        {"login": "\(login)", "password": "\(password.sha256())"
        }
        """
      
        //writeTextToFile(fileName: "user\(login).txt", text: stringJson+"\n")
      
        WorkWithFile(folder: "Users", fileName: "user\(login)").writeTextToFile(text: stringJson)
        
        
        let jsonData = stringJson.parseJSONString
        if jsonData == nil{
            print("jsonData nil")
        }else{
            print("jsonData valid")
        }
        let tmp = jsonData as! [String: Any]
       
      
        print("---REGISTRATION END---")
    }
    var name:String = ""
    var sources:[Source] = []
    
    
    
}

