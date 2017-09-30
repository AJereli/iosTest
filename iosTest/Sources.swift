//
//  Sources.swift
//  iosTest
//
//  Created by User on 29/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation


struct Source {
    var sourceName:String!
    var sourceLink:String!
    var isSelected:Bool = false
}


class Sources {
    
    var sourcesArray:[Source] = [Source]()
    
    
    
    private init() {
        sourcesArray = loadAllSources();
    }
    
    static private var sources!
    
    static func getSources () -> Sources{
        if (sources == nil){
            sources = Sources()
        }
        return sources
    }
    
    func getSource(index:Int) -> Source{
        return sourcesArray[index]
    }
    
    func count () -> Int{
        return sourcesArray.count
    }
    
    private func loadAllSources () -> [Source] {
            return [Source(sourceName: "Google", sourceLink: "https://stackoverflow.com", isSelected: false), Source(sourceName: "StackOverflow", sourceLink: "https://stackoverflow.com", isSelected:true)]
    }
    
    
    
    
    
}
