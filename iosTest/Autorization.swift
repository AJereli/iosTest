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
            catch _ {
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
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(fileName)
            
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print("error with file Z")
            }
            
           
          
        }
    }
    
    
    func autorization(){
        
    }
    func registration(){
        
        let stringJson:String = """
        {
            login: \(login),
            password: \(password.sha256()),
            sources: \([])
        }
        """
        writeTextToFile(fileName: "usersJson", text: stringJson+"\n")
        
        let jsonData = stringJson.parseJSONString
        if jsonData == nil{
            print("jsonData nil")
        }else{
            print("jsonData valid")
        }
        let tmp = jsonData as! [String: Any]
        print(tmp["login"])
//        do {
//            if let data = jsonData,
//                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                let user = json["user"] as? [String: Any] {
//
//                if let login = user["login"] as? String {
//                    print(login)
//                }
//            }
//        } catch {
//            print("Error deserializing JSON: \(error)")
//        }
        
//
//
//        for (k, v) in json{
//            print(k + (v as! String))
//        }
        
        //        if let myData = json as! Data{
//            do{
//                let myJson = try JSONSerialization.jsonObject(with: myData, options: JSONSerialization.ReadingOptions.mutableContainers) as Any
//                if let data = myJson["login"] as String? {
//                   print(login)
//                }
//            }
//
//            catch{
//
//            }
//        }
//        print("Parsed JSON: \(json!)")
//        if let data = try? JSONSerialization.data(withJSONObject: userJsonObject),
//            let string = String(data: data, encoding: .utf8){
//            print(string)
//        }
//        let userJsonObject: [String: Any] = [
//            "login": login,
//            "password": password.sha256(),
//            "sources": []
//
//        ]
        
    }
    var name:String = ""
    var sources:[Source] = []
    
    
    
}

