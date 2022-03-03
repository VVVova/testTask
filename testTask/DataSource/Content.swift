//
//  DataSource.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import Foundation
protocol dataSourceProtocol{
    func dataSourceIsLoaded(articles:[Articles])
}
class Content {
    var dataSourseDelegate : dataSourceProtocol?
    var dataSource : [Articles] = []
    var dataImges : [Data] = []
    let api = URL.init(string: "https://newsapi.org/v2/everything?q=Apple&from=2022-03-01&sortBy=popularity&apiKey=11bbc0dc963743ea8ed55c3bfab9e5de")
    init(){
        getData(comp: { [self] articles in
            dataSource = articles
        })
    }
    func getData(comp: @escaping ([Articles]) ->()){
        if let url = self.api{
            URLSession.shared.dataTask(with: url) { [self] data, response, error in
                guard let data = data,error == nil else {
                    print("Error")
                    return
                }
                var response : Response?
                do{
                    response = try JSONDecoder().decode(Response.self, from: data)
                }catch{
                    print("error parse response with error \(error.localizedDescription)")
                }
                guard let json = response else{
                    return
                }
                dataImges = loadImages(articles: json.articles)
                dataSourseDelegate?.dataSourceIsLoaded(articles: json.articles)
                comp(json.articles)
            }.resume()
        }
    }
    func loadImages(articles:[Articles])->[Data]{
        var images : [Data] = [Data]()
        for i in articles{
            if let urlImage = i.urlToImage{
                getData(from: urlImage) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? urlImage.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    images.append(data)
                }
            }
        }
        return images
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
