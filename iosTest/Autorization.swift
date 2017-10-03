//
//  Autorization.swift
//  iosTest
//
//  Created by User on 02/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

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
//        switch userAction {
//        case UserAction.authorization:
//            autorization()
//        case UserAction.registration:
//            registration()
//        default: break
//        }
        
        
    }
    
    private func autorization(){
        
    }
    func registration(){
        let userJsonObject: [String: Any] = [
            "login": login,
            "password": password.sha256(),
            "sources": []
           
        ]
        if JSONSerialization.isValidJSONObject(userJsonObject){
            
        }
        
    }
    var name:String = ""
    var sources:[Source] = []
    
    
    
}

