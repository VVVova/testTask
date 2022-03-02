//
//  DataSource.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import Foundation
class Content {
    var queue = DispatchQueue.init(label: "getContent",qos: .unspecified)
    var dataSource : [Articles] = [Articles]()
    let api = URL.init(string: "https://newsapi.org/v2/everything?q=Apple&from=2022-03-01&sortBy=popularity&apiKey=11bbc0dc963743ea8ed55c3bfab9e5de")
    func getData(){
        queue.async {
            if let url = self.api{
                URLSession.shared.dataTask(with: url) { data, response, error in
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
                    print(json.articles)
                    self.dataSource = json.articles
                }.resume()
            }
        }
    }
    init(){
        getData()
    }
}
