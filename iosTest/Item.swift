//
//  Item.swift
//  iosTest
//
//  Created by User on 26/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit


struct Item {
    
    var title:String
    var imageUrl:URL
    var description:String
    var newsUrl:String
    init? (title:String, imageUrl:URL, description:String, newsUrl:String	){
        
        
        guard !title.isEmpty else {
            return nil
        }
        guard !description.isEmpty else{
            return nil
        }

        self.title = title
        self.imageUrl = imageUrl
        self.description = description
        self.newsUrl = newsUrl
    }
}

