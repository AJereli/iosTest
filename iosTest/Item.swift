//
//  Item.swift
//  iosTest
//
//  Created by User on 26/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit


class Item {
    
    var title:String
    var image:UIImage?
    var description:String
    var newsUrl:String
    init? (title:String, image:UIImage?, description:String, newsUrl:String	){
        
        
        guard !title.isEmpty else {
            return nil
        }
        guard !description.isEmpty else{
            return nil
        }

        self.title = title
        self.image = image
        self.description = description
        self.newsUrl = newsUrl
    }
    
    
    
}
