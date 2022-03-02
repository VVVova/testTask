//
//  DataBase.swift
//  testTask
//
//  Created by Developer on 02.03.2022.
//

import Foundation
import CoreData
import WebKit
func saveArticles(articles:[Articles],object:NSManagedObject,context:NSManagedObjectContext){
    for i in articles{
        object.setValue(i.source?.id ?? "", forKey: "id")
        object.setValue(i.source?.name ?? "", forKey: "name")
        object.setValue(i.title, forKey: "title")
        object.setValue(i.author, forKey: "author")
        object.setValue(i.description, forKey: "descriptionArticle")
        object.setValue(i.url, forKey: "url")
        object.setValue(i.urlToImage, forKey: "urlToImage")
        object.setValue(i.content, forKey: "content")
        object.setValue(i.publishedAt, forKey: "publishedAt")
        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
func getArticlesFromCoreData(nameEntity:String)->[DataSourceArticle]?
{
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
    let managedContext =
    appDelegate.persistentContainer.viewContext
    let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: nameEntity)
    fetchrequest.resultType = NSFetchRequestResultType.dictionaryResultType
    var returnDict = [[String:Any]]()
    do {
        let results = try managedContext.fetch(fetchrequest)
        if let resultsDict = results as? [[String:Any]]{
            returnDict = resultsDict
        }else{
            return nil
        }
    } catch let err as NSError {
        print(err.debugDescription)
    }
    var articles = getDataSoursArticles(data: returnDict)
    print("Data \(nameEntity) = \(returnDict)")
    return articles
}
func getDataSoursArticles(data: [[String:Any]])->[DataSourceArticle]{
    var articles : [DataSourceArticle] = []
    for i in data{
        let article = getDataSourseArticle(data: i)
        articles.append(article)
    }
    return articles
}
func getDataSourseArticle(data:[String:Any])->DataSourceArticle{
    var article = DataSourceArticle.init()
    var source = DataSourceSource.init()
    source.id = data["id"] as? String ?? ""
    source.name = data["name"] as? String ?? ""
    //==========================================================
    article.source = source
    article.title = data["title"] as? String ?? ""
    article.author = data["author"] as? String ?? ""
    article.description = data["descriptionArticle"] as? String ?? ""
    article.url = data["url"] as? URL ?? nil
    article.urlToImage = data["urlToImage"] as? URL ?? nil
    article.publishedAt = data["publishedAt"] as? String ?? ""
    article.content = data["content"] as? String ?? ""
    return article
}
