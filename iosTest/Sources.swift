//
//  Sources.swift
//  iosTest
//
//  Created by User on 29/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation


class Source {
    var sourceName:String!
    var sourceLink:String!
    var isSelected:Bool = false
    
    init (sourceName:String!, sourceLink:String!, isSelected:Bool = false){
        self.sourceName = sourceName
        self.sourceLink = sourceLink
    }
}


class Sources {
    
    var allSources:[Source] = [Source]()
    var favoritsSources:[Source] = [Source]()
    
    var user:User?
    
    private init() {
        allSources = loadAllSources()
        
    }
    
    static private var sources:Sources!
    
    static func getSources () -> Sources{
        if (sources == nil){
            sources = Sources()
        }
        return sources
    }
    func setAllSelections (sourcesLinks:[String], isSelected:Bool = true){
        for s in sourcesLinks{
            allSources.first(where:
                { (source:Source) -> Bool in
                source.sourceLink == s
            })?.isSelected = isSelected
        }
        updateFavoritsSources()
    }
    
    func setSelection (sourceLink:String, isSelected:Bool){
        setAllSelections(sourcesLinks: [sourceLink], isSelected: isSelected)
    }
    

    private func loadAllSources () -> [Source] {
            return [Source(sourceName: "Google", sourceLink: "https://google.com", isSelected: false), Source(sourceName: "StackOverflow", sourceLink: "https://stackoverflow.com", isSelected:false)]
    }
    
    private func updateFavoritsSources (){
        let selected:[Source] = allSources.filter { (s:Source) -> Bool in
            s.isSelected
        }
        favoritsSources = selected
        
        var selectedSourceLinks:[String] = [String]()
        for sources in selected{
            selectedSourceLinks.append("\"" + sources.sourceLink + "\"")
        }
        
        let  selectedJsonString = "[" + selectedSourceLinks.joined(separator: ",") + "]"
        
        let stringJson:String = """
        {"login": "\(user!.userName)",
        "password": "\(user!.userPassword)",
        "sources": \(selectedJsonString)
        }
        """
        
        if WorkWithFile(folder: "Users", fileName: "user" + user!.userName).writeTextToFile(text: stringJson){
            print("(UPDATE Favors)\n String writed to file \n \(stringJson)\n")
        }
        
    }
    
    
    
    
}
