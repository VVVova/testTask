//
//  ViewController.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import UIKit

class ViewController: UIViewController,dataSourceProtocol{
    
    func dataSourceIsLoaded(articles: [Articles]) {
        dataSource = articles
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
    var content = Content.init()
    var dataSource : [Articles] = []
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        content.dataSourseDelegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = dataSource[indexPath.row].url else{
            return
        }
        let title = dataSource[indexPath.row].author ?? ""
        let vc = WebViewViewController(url: url, title: title)
        let navCon = UINavigationController(rootViewController: vc)
        present(navCon, animated: true, completion: nil)
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell else{
            return UITableViewCell()
        }
        cell.title.text = dataSource[indexPath.row].title ?? ""
        cell.author.text = dataSource[indexPath.row].author ?? ""
        cell.source.text = "\(dataSource[indexPath.row].source?.id ?? "" )  \(dataSource[indexPath.row].source?.name ?? "" )"
        cell.descpript.text = dataSource[indexPath.row].description ?? ""
        cell.imageUrl = dataSource[indexPath.row].urlToImage
        return cell
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
//    if let urlImage = dataSource[indexPath.row].urlToImage {
//        getData(from: urlImage) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? urlImage.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async {
//                cell.imageCon.image = UIImage(data: data)
//                tableView.cellForRow(at: indexPath)
//            }
//        }
//    }
}
