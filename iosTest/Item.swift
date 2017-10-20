//
//  Item.swift
//  iosTest
//
//  Created by User on 26/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import AlamofireImage

class Item {
    
    var id:Int
    var title:String
    var imageUrl:URL
    var image:UIImage?
    var description:String
    var newsUrl:String
    init? (id:Int, title:String, imageUrl:URL, description:String, newsUrl:String	){
        
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.description = description
        self.newsUrl = newsUrl
        
    }
    
    func downloadImage () -> Promise<UIImage>{
        return Promise{ fulfill, reject in
            if (image != nil) {
                fulfill(image!)
            }else{
                Alamofire.request(imageUrl).validate().responseImage { response in
                    switch response.result{
                    case .success(let value):
                        
                        fulfill(value as UIImage)
                        
                    case .failure(let error):
                        print(error)
                        reject(error)
                    }
                    
                }
                
            }
        }
    }
}

