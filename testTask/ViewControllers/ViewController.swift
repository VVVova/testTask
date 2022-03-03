//
//  ViewController.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import UIKit
class ViewController: UIViewController,dataSourceProtocol{
    var content = Content.init()
    func dataSourceIsLoaded(articles: [Articles]) {
        dataSource = articles
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
    var filtMethod : String = ""
    override func viewDidAppear(_ animated: Bool) {
    }
    //DataSource
    var filteredDataSource : [Articles] = []
    var dataSource : [Articles] = []
    //UIElements
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        searchBar.delegate = self
        content.dataSourseDelegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        swipeDown.delegate = self
        swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
        self.tableView.addGestureRecognizer(swipeDown)
        self.pickerViewOutlet.delegate = self
        self.pickerViewOutlet.dataSource = self
    }
    @objc func refresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    //piker view
    
    @IBOutlet weak var pickerViewOutlet: UIPickerView!
    var pickerData = ["no filtering","Sorting by publishedAt","Filtering by category","Filtering by country","Filtering by sources"]
    
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = dataSource[indexPath.row].url else{
            return
        }
        let title = dataSource[indexPath.row].author ?? ""
        let vc = WebViewViewController(url: url, title: title,article: [dataSource[indexPath.row]])
        let navCon = UINavigationController(rootViewController: vc)
        present(navCon, animated: true, completion: nil)
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredDataSource.isEmpty{
            return dataSource.count
        }else{
            return filteredDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell else{
            return UITableViewCell()
        }
        if filteredDataSource.isEmpty{
            cell.title.text =  dataSource[indexPath.row].title ?? ""
            cell.author.text = "Author : " + (dataSource[indexPath.row].author ?? "" )
            cell.id.text = "ID  : \(dataSource[indexPath.row].source?.id ?? "")"
            cell.name.text = "Name  : \(dataSource[indexPath.row].source?.name ?? "")"
            cell.descpript.text = dataSource[indexPath.row].description ?? ""
            cell.imageUrl = dataSource[indexPath.row].urlToImage
            return cell
        }else{
            cell.title.text =  filteredDataSource[indexPath.row].title ?? ""
            cell.author.text = "Author : " + (filteredDataSource[indexPath.row].author ?? "" )
            cell.id.text = "ID  : \(filteredDataSource[indexPath.row].source?.id ?? "")"
            cell.name.text = "Name  : \(filteredDataSource[indexPath.row].source?.name ?? "")"
            cell.descpript.text = filteredDataSource[indexPath.row].description ?? ""
            cell.imageUrl = filteredDataSource[indexPath.row].urlToImage
            return cell
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var articles : [Articles] = []
        filteredDataSource = dataSource.filter({( aricle : Articles) -> Bool in
            return aricle.title?.contains(searchText) ?? false
        })
        print(filteredDataSource.count)
        tableView.reloadData()
        
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
}
extension ViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    @objc func hideKeyboardOnSwipeDown() {
            view.endEditing(true)
    }
}
//sorting
extension ViewController{
    func sortingByPublishedAt()->[Articles]{
        var sourse : [Articles] = []
        if !filteredDataSource.isEmpty{
            sourse = filteredDataSource
        }else{
            sourse = dataSource
        }
        var convertedArray: [Date] = []
        var sortingDataSource : [Articles] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"// yyyy-MM-dd"

        for dat in sourse {
            let date = dateFormatter.date(from: dat.publishedAt ?? "")
            if let date = date {
                convertedArray.append(date)
            }
        }
        let ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
        for date in ready{
            let strDate = dateFormatter.string(from: date)
            for art in sourse{
                if art.publishedAt == strDate{
                    sortingDataSource.append(art)
                }
            }
        }
        return sortingDataSource
    }
}
//filtering
extension ViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var filtMethod = pickerData[row]
        sortAndFilter(method: filtMethod)
    }
    func sortAndFilter(method: String) {
        switch method{
        case "no filtering":
            filteredDataSource = []
            tableView.reloadData()
        case "Sorting by publishedAt":
            if !dataSource.isEmpty {
                filteredDataSource = sortingByPublishedAt()
                tableView.reloadData()
            }
        default:
            filtering(by: method)
        }
    }
    func filtering(by:String){
        switch by{
        case "Filtering by category":
            break
        case "Filtering by country":
            break
        case "Filtering by sources":
            fiterBySource()
            tableView.reloadData()
            break
        default:
            break
        }
    }
    func fiterBySource(){
        if !dataSource.isEmpty{
            filteredDataSource =  dataSource.sorted(by: {$0.source?.name ?? "" < $1.source?.name ?? ""})
        }else{
            if !filteredDataSource.isEmpty{
            filteredDataSource = filteredDataSource.sorted(by: {$0.source?.name ?? "" < $1.source?.name ?? ""})
            }
        }
    }
}
/*
 private func setupGestures(){
     let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
     tapGesture.numberOfTapsRequired = 1
     selectFilerDataSourceOutlet.addGestureRecognizer(tapGesture)
 }
 @objc func tapped(){
     guard let popVC = storyboard?.instantiateViewController(withIdentifier: "menu") else {return}
     popVC.modalPresentationStyle = .popover
     let popOverVC = popVC.popoverPresentationController
     popOverVC?.delegate = self
     popOverVC?.sourceView = selectFilerDataSourceOutlet
     popOverVC?.sourceRect = CGRect.init(x: self.selectFilerDataSourceOutlet.bounds.midX, y: self.selectFilerDataSourceOutlet.bounds.minY, width: 0, height: 0)
     popVC.preferredContentSize = CGSize(width: 350, height: 250)
     self.present(popVC, animated: true, completion: nil)
 extension ViewController : UIPopoverPresentationControllerDelegate{
     func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
         return .none
     }
 }
 }
 */
