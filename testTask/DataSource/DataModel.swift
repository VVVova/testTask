//
//  DataModel.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import Foundation
//Parse Response
struct Response : Codable{
    var status : String?
    var totalResults : Int?
    var articles : [Articles]    
}
struct Articles : Codable{
    let source : Source?
    var author : String?
    var title : String?
    var description : String?
    var url : URL?
    var urlToImage : URL?
    var publishedAt : String?
    var content : String?
    
    static func ==(left:Articles,rigth:Articles)->Bool{
        if left.description == rigth.description {
            return true
        }else{
            return false
        }
    }
}
struct Source : Codable{
    var id : String?
    var name : String?
}
// Parse frorm CoreData
struct DataSourceArticle {
    var source : DataSourceSource?
    var author : String?
    var title : String?
    var description : String?
    var url : URL?
    var urlToImage : URL?
    var publishedAt : String?
    var content : String?
    init(source:DataSourceSource,
         author : String?,
         title : String?,
         description : String?,
         url : URL?,
         urlToImage : URL?,
         publishedAt : String?,
         content : String?){
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    init(){}
}
struct DataSourceSource{
    var id : String?
    var name : String?
    init(id:String?,name:String?){
        self.id = id
        self.name = name
    }
    init(){}
}
