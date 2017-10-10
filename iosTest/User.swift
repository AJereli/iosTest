//
//  User.swift
//  iosTest
//
//  Created by User on 05/10/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation


class User {
    
    let userName:String
    let userPassword:String
    var favoriteSources:[String]
    
    init (userName:String, userPassword:String, favoriteSources:[String]){
        self.userName = userName
        self.userPassword = userPassword
        self.favoriteSources = favoriteSources
    }
}
