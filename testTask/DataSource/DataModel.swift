//
//  DataModel.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import Foundation
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
}
struct Source : Codable{
    var id : String?
    var name : String?
}
