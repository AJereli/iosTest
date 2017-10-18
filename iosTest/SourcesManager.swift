//
//  Sources.swift
//  iosTest
//
//  Created by User on 29/09/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import AlamofireImage

class Source {
    var sourceName:String!
    var sourceLink:String!
    var isSelected:Bool = false
    var items:[Item] = [Item]()
    var currLoadCnt:Int = 0
    
    
    init (sourceName:String!, sourceLink:String!){
        self.sourceName = sourceName
        self.sourceLink = sourceLink
    }
    
    private func checkForNewItems() -> Bool {
        
        let sourcesJson = WorkWithFile(folder: "Items", fileName: "items").jsonFromFile() as? [String:Any]
        let unParsedItems = sourcesJson![sourceLink] as! [[String:String]]
        
        let maxId = unParsedItems.max(by: { a, b -> Bool in
            Int(a["id"]!)! < Int (b["id"]!)!
        })!["id"]

        if Int(maxId!)! > currLoadCnt - 1{
            return true
        }else{
            return false
        }
        
    }
    
    func loadItemsFromSource(limit:Int) -> Promise<[Item]>{
        return Promise{ fulfill, reject in
            let sourcesJson = WorkWithFile(folder: "Items", fileName: "items").jsonFromFile() as? [String:Any]
            let unParsedItems = sourcesJson![sourceLink] as! [[String:String]]
            var cnt = 0
            var newItems:[Item] = [Item]()
            if checkForNewItems() {
                for item in unParsedItems{
                    let id = Int(item["id"]!)!
                    
                    if !items.contains(where: {
                        (someItem) -> Bool in
                        someItem.id == id
                    }){
                        let item = Item(id: id, title: item["title"]!, imageUrl: URL(string: item["imageUrl"]!)!, description: item["description"]!, newsUrl: item["newsUrl"]!)!
                        items.append(item)
                        cnt += 1
                        currLoadCnt += 1
                    }
                    
                    if cnt == limit{
                        break
                    }
                }
            }
            
            fulfill(items)
        }
        
        
    }
    func loadItemsFromSourceSync(limit:Int) -> [Item]{
        
        let sourcesJson = WorkWithFile(folder: "Items", fileName: "items").jsonFromFile() as? [String:Any]
        let unParsedItems = sourcesJson![sourceLink] as! [[String:String]]
        var cnt = 0
        var newItems:[Item] = [Item]()
        if checkForNewItems() {
            for item in unParsedItems{
                let id = Int(item["id"]!)!
                
                if !items.contains(where: {
                    (someItem) -> Bool in
                    someItem.id == id
                }){
                    let item = Item(id: id, title: item["title"]!, imageUrl: URL(string: item["imageUrl"]!)!, description: item["description"]!, newsUrl: item["newsUrl"]!)!
                    items.append(item)
                    cnt += 1
                    currLoadCnt += 1
                }
                
                if cnt == limit{
                    break
                }
            }
        }
        return items
    }
   
    
}
    


class SourcesManager {
    
    var allSources:[Source] = [Source]()
    private var favoritsSources:[Source] = [Source]()

    var user:User?
    
    private init() {
        allSources = loadAllSources()
        createMockItems()
    }
    
    static private var sources:SourcesManager!
    
    static func getInstance () -> SourcesManager{
        if (sources == nil){
            sources = SourcesManager()
        }
        return sources
    }
    
    func loadItems (limitForSource:Int) -> [Item]{
        var items:[Item] = [Item]()

        for source in favoritsSources{
            items += source.loadItemsFromSource(limit: limitForSource).value!
        }
        return items
        
    }
    
    func loadItemsAsync (limitForSource:Int) -> Promise<[Item]>{
        return Promise { fulfill, reject in
            var items:[Item] = [Item]()
            
            for source in favoritsSources{
                items += source.loadItemsFromSourceSync(limit: limitForSource)
            }
            
            fulfill(items)
        }
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
            return [Source(sourceName: "Habrahabr", sourceLink: "https://habrahabr.ru"), Source(sourceName: "Geektimes", sourceLink: "https://geektimes.ru")]
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
            //print("(UPDATE Favors)\n String writed to file \n \(stringJson)\n")
        }
        
    }
    private func createMockItems (){
        let stringJson:String = """
        {
            "https://habrahabr.ru": [{
                    "id" : "0",
                    "title": "На пути к естественному интеллекту",
                    "imageUrl": "https://habrastorage.org/getpro/habr/post_images/4a2/de3/232/4a2de32322fd0a1d353ffae701f5ec70.jpg",
                    "description": "Machine Learning с каждым днём становится всё больше. Кажется, что любая компания, у которой есть хотя бы пять сотрудников, хочет себе разработать или купить решение на машинном обучении. Считать овец, считать свёклу, считать покупателей, считать товар. Либо прогнозировать всё то же самое.",
                    "newsUrl": "https://habrahabr.ru/company/jugru/blog/339806/"
                },
                {
                    "id" : "1",
                    "title": "JavaScript ES8 и переход на async / await",
                    "imageUrl": "https://habrastorage.org/getpro/habr/post_images/62c/d3f/b31/62cd3fb315a5f5b12d7de940349edef8.jpg",
                    "description": "Недавно мы опубликовали материал «Промисы в ES6: паттерны и анти-паттерны». Он вызвал серьёзный интерес аудитории, в комментариях к нему наши читатели рассуждали об особенностях написания асинхронного кода в современных JS-проектах. Кстати, советуем почитать их комментарии — найдёте там много интересного.",
                    "newsUrl": "https://habrahabr.ru/company/ruvds/blog/339770/"
                }
            ],
            "https://geektimes.ru": [{
                    "id" : "0",
                    "title": "На пути к естественному интеллекту",
                    "imageUrl": "https://habrastorage.org/webt/59/dc/fb/59dcfb8fe4c4e906279297.jpeg",
                    "description": "Начнём с традиционного «Этот материал представлен только в образовательных целях». Если вы используете эту информацию для взлома HBO и выпуска следующего сезона «Игры престолов» бесплатно на YouTube, ну… здорово. В том смысле, что я никак не поощряю подобное поведение.",
                    "newsUrl": "https://geektimes.ru/post/294271/"
                },
                {
                    "id" : "1",
                    "title": "Астроному на заметку: экваториальная монтировка своими руками",
                    "imageUrl": "https://habrastorage.org/getpro/geektimes/post_images/ef0/4b7/abe/ef04b7abedcb1ba0cb98c9e8087e3ad2.jpg",
                    "description": "Несколько лет назад я с женой побывал в научном отпуске. Мы потратили немало времени, колеся по прекрасному американскому Юго-Западу, посетили много замечательных природных парков на плато Колорадо. Проехав сотни километров по безлюдным местам под ясным звёздным небом, я начал мечтать об экваториальной монтировке — платформе для фотокамеры, которая будет вращаться, чтобы компенсировать вращение планеты. При съёмке звёзд со штатива более-менее длинная выдержка приведёт к тому, что звёзды превратятся в световые штрихи. Это любопытный художественный эффект, но он не позволяет астрофотографу запечатлеть тонкие подробности звёздного неба. Мысленно я высчитывал передаточные отношения шестерёнок редуктора для монтировки, пока моя жена спала на соседнем сиденье. Вернувшись из поездки, я начал подбирать инструменты для реализации своей мечты. Создавать экваториальную монтировку я решил из листового акрила, а шестерёнки нарезать лазером. В качестве ПО для проектирования механики и создания чертежей я взял Autodesk Inventor. Ссылки на чертежи:",
                    "newsUrl": "https://geektimes.ru/company/mailru/blog/294249/"
                }
                ,
                {
                    "id" : "2",
                    "title": "TEST2",
                    "imageUrl": "https://habrastorage.org/getpro/geektimes/post_images/ef0/4b7/abe/ef04b7abedcb1ba0cb98c9e8087e3ad2.jpg",
                    "description": "Несколько лет назад я с женой побывал в научном отпуске. Мы потратили немало времени, колеся по прекрасному американскому Юго-Западу, посетили много замечательных природных парков на плато Колорадо. Проехав сотни километров по безлюдным местам под ясным звёздным небом, я начал мечтать об экваториальной монтировке — платформе для фотокамеры, которая будет вращаться, чтобы компенсировать вращение планеты. При съёмке звёзд со штатива более-менее длинная выдержка приведёт к тому, что звёзды превратятся в световые штрихи. Это любопытный художественный эффект, но он не позволяет астрофотографу запечатлеть тонкие подробности звёздного неба. Мысленно я высчитывал передаточные отношения шестерёнок редуктора для монтировки, пока моя жена спала на соседнем сиденье. Вернувшись из поездки, я начал подбирать инструменты для реализации своей мечты. Создавать экваториальную монтировку я решил из листового акрила, а шестерёнки нарезать лазером. В качестве ПО для проектирования механики и создания чертежей я взял Autodesk Inventor. Ссылки на чертежи:",
                    "newsUrl": "https://geektimes.ru/company/mailru/blog/294249/"
                } ,
                {
                    "id" : "3",
                    "title": "TEST3",
                    "imageUrl": "https://habrastorage.org/getpro/geektimes/post_images/ef0/4b7/abe/ef04b7abedcb1ba0cb98c9e8087e3ad2.jpg",
                    "description": "Несколько лет назад я с женой побывал в научном отпуске. Мы потратили немало времени, колеся по прекрасному американскому Юго-Западу, посетили много замечательных природных парков на плато Колорадо. Проехав сотни километров по безлюдным местам под ясным звёздным небом, я начал мечтать об экваториальной монтировке — платформе для фотокамеры, которая будет вращаться, чтобы компенсировать вращение планеты. При съёмке звёзд со штатива более-менее длинная выдержка приведёт к тому, что звёзды превратятся в световые штрихи. Это любопытный художественный эффект, но он не позволяет астрофотографу запечатлеть тонкие подробности звёздного неба. Мысленно я высчитывал передаточные отношения шестерёнок редуктора для монтировки, пока моя жена спала на соседнем сиденье. Вернувшись из поездки, я начал подбирать инструменты для реализации своей мечты. Создавать экваториальную монтировку я решил из листового акрила, а шестерёнки нарезать лазером. В качестве ПО для проектирования механики и создания чертежей я взял Autodesk Inventor. Ссылки на чертежи:",
                    "newsUrl": "https://geektimes.ru/company/mailru/blog/294249/"
                } ,
                {
                    "id" : "4",
                    "title": "TEST4",
                    "imageUrl": "https://habrastorage.org/getpro/geektimes/post_images/ef0/4b7/abe/ef04b7abedcb1ba0cb98c9e8087e3ad2.jpg",
                    "description": "Несколько лет назад я с женой побывал в научном отпуске. Мы потратили немало времени, колеся по прекрасному американскому Юго-Западу, посетили много замечательных природных парков на плато Колорадо. Проехав сотни километров по безлюдным местам под ясным звёздным небом, я начал мечтать об экваториальной монтировке — платформе для фотокамеры, которая будет вращаться, чтобы компенсировать вращение планеты. При съёмке звёзд со штатива более-менее длинная выдержка приведёт к тому, что звёзды превратятся в световые штрихи. Это любопытный художественный эффект, но он не позволяет астрофотографу запечатлеть тонкие подробности звёздного неба. Мысленно я высчитывал передаточные отношения шестерёнок редуктора для монтировки, пока моя жена спала на соседнем сиденье. Вернувшись из поездки, я начал подбирать инструменты для реализации своей мечты. Создавать экваториальную монтировку я решил из листового акрила, а шестерёнки нарезать лазером. В качестве ПО для проектирования механики и создания чертежей я взял Autodesk Inventor. Ссылки на чертежи:",
                    "newsUrl": "https://geektimes.ru/company/mailru/blog/294249/"
                } ,
                {
                    "id" : "5",
                    "title": "TEST5",
                    "imageUrl": "https://habrastorage.org/getpro/geektimes/post_images/ef0/4b7/abe/ef04b7abedcb1ba0cb98c9e8087e3ad2.jpg",
                    "description": "Несколько лет назад я с женой побывал в научном отпуске. Мы потратили немало времени, колеся по прекрасному американскому Юго-Западу, посетили много замечательных природных парков на плато Колорадо. Проехав сотни километров по безлюдным местам под ясным звёздным небом, я начал мечтать об экваториальной монтировке — платформе для фотокамеры, которая будет вращаться, чтобы компенсировать вращение планеты. При съёмке звёзд со штатива более-менее длинная выдержка приведёт к тому, что звёзды превратятся в световые штрихи. Это любопытный художественный эффект, но он не позволяет астрофотографу запечатлеть тонкие подробности звёздного неба. Мысленно я высчитывал передаточные отношения шестерёнок редуктора для монтировки, пока моя жена спала на соседнем сиденье. Вернувшись из поездки, я начал подбирать инструменты для реализации своей мечты. Создавать экваториальную монтировку я решил из листового акрила, а шестерёнки нарезать лазером. В качестве ПО для проектирования механики и создания чертежей я взял Autodesk Inventor. Ссылки на чертежи:",
                    "newsUrl": "https://geektimes.ru/company/mailru/blog/294249/"
                } ,
                {
                    "id" : "6",
                    "title": "TEST6",
                    "imageUrl": "https://habrastorage.org/getpro/geektimes/post_images/ef0/4b7/abe/ef04b7abedcb1ba0cb98c9e8087e3ad2.jpg",
                    "description": "Несколько лет назад я с женой побывал в научном отпуске. Мы потратили немало времени, колеся по прекрасному американскому Юго-Западу, посетили много замечательных природных парков на плато Колорадо. Проехав сотни километров по безлюдным местам под ясным звёздным небом, я начал мечтать об экваториальной монтировке — платформе для фотокамеры, которая будет вращаться, чтобы компенсировать вращение планеты. При съёмке звёзд со штатива более-менее длинная выдержка приведёт к тому, что звёзды превратятся в световые штрихи. Это любопытный художественный эффект, но он не позволяет астрофотографу запечатлеть тонкие подробности звёздного неба. Мысленно я высчитывал передаточные отношения шестерёнок редуктора для монтировки, пока моя жена спала на соседнем сиденье. Вернувшись из поездки, я начал подбирать инструменты для реализации своей мечты. Создавать экваториальную монтировку я решил из листового акрила, а шестерёнки нарезать лазером. В качестве ПО для проектирования механики и создания чертежей я взял Autodesk Inventor. Ссылки на чертежи:",
                    "newsUrl": "https://geektimes.ru/company/mailru/blog/294249/"
                }
            ]
        }
        """
        WorkWithFile(folder: "Items", fileName: "items").writeTextToFile(text: stringJson)
        
    }
    
    
    
}
