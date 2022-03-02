//
//  ViewController.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import UIKit

class ViewController: UIViewController{
    var content = Content.init()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
    }
    override func viewDidAppear(_ animated: Bool) {
        if !content.dataSource.isEmpty{
            tableView.reloadData()
        }
    }
}
extension ViewController : UITableViewDelegate{
    
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if content.dataSource.isEmpty{
          return 1
         }else{
             return content.dataSource.count
         }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell else{
            return UITableViewCell()
        }
        return cell
    }
    
    
}
