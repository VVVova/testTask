//
//  SelectedArticlesViewController.swift
//  testTask
//
//  Created by Developer on 02.03.2022.
//

import UIKit
import CoreData
class SelectedArticlesViewController: UIViewController {
    var dataSource : [DataSourceArticle]? = []
    var dataBase = DataBase.init()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = dataBase.getArticlesFromCoreData(nameEntity: "Article")
    }
}
extension SelectedArticlesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell else{
            return UITableViewCell()
        }
        cell.title.text =  dataSource?[indexPath.row].title ?? ""
        cell.author.text = "Author : \(dataSource?[indexPath.row].author ?? "")"
        cell.id.text = "ID  : \(dataSource?[indexPath.row].source?.id ?? "")"
        cell.name.text = "Name  : \(dataSource?[indexPath.row].source?.name ?? "")"
        cell.descpript.text = dataSource?[indexPath.row].description ?? ""
        cell.imageUrl = dataSource?[indexPath.row].urlToImage
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = dataSource?[indexPath.row].url else{
            return
        }
        let title = dataSource?[indexPath.row].author ?? ""
        let data = [dataSource?[indexPath.row]]
        let vc = WebViewViewController(url: url, title: title, dataSourceArticle: data)
        let navCon = UINavigationController(rootViewController: vc)
        present(navCon, animated: true, completion: nil)
    }
}

