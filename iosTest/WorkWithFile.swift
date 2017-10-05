//
//  WorkWithFile.swift
//  iosTest
//
//  Created by User on 04/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

class WorkWithFile {
    
    private let path:String
    private let writePath:URL
    private let file:URL
    
    let folder:String
    let fileName:String
    
    init (folder:String, fileName:String){
        self.folder = folder
        self.fileName = fileName
        path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder)!
        file = writePath.appendingPathComponent(fileName + ".txt")
    }
    
    func readTextFromFile () -> String?{
        let text:String?
        do{
            if !FileManager.default.fileExists(atPath: writePath.path) {
                try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
            }
            try text = String(contentsOf: file, encoding: .utf8)
            
        }
        catch{
            text = nil
        }
        print ("Read from file \(fileName) success with text:\n\(text!)")

        return text
    }
    
    func writeTextToFile(text:String) -> Bool{
        
        if !FileManager.default.fileExists(atPath: writePath.path) {
            try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        }
        
        do {
            try text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
            
        }
        catch {
            print("error with file")
            return false
        }
        print ("Write to file \(fileName) success with text:\n\(text)")
        return true
    }
}
