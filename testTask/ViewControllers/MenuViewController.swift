//
//  MenuViewController.swift
//  testTask
//
//  Created by Developer on 02.03.2022.
//

import UIKit
protocol sortingEventDelegate{
    func sort(method:String)
}
class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    static var shared = MenuViewController()
    var filters : [String] = ["Sorting by publishedAt","Filtering by category","Filtering by country","Filtering by sources"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "cell") else{
            return UITableViewCell()
        }
        cell.textLabel?.text = filters[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMethod = filters[indexPath.row]
        prepare(for: UIStoryboardSegue.init(identifier: "menu", source: MenuViewController(), destination: ViewController()), sender: nil)
        sortEventDelegate?.sort(method: selectedMethod)
        self.dismiss(animated: true, completion: nil)
    }
    var sortEventDelegate : sortingEventDelegate? = nil
    var selectedMethod : String = ""

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ViewController {
            target.filtMethod = selectedMethod
        }
    }
}
