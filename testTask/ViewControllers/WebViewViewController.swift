//
//  WebViewViewController.swift
//  testTask
//
//  Created by Developer on 02.03.2022.
//

import UIKit
import CoreData
import WebKit
class WebViewViewController: UIViewController {
    private let url : URL
    var dataBase = DataBase.init()
    init(url:URL,title:String,article:[Articles]){
        self.url = url
        self.article = article
        self.dataSourceArticle = []
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    init(url:URL,title:String,dataSourceArticle:[DataSourceArticle?]){
        self.url = url
        self.dataSourceArticle = dataSourceArticle
        self.article = []
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    var article : [Articles]
    var dataSourceArticle : [DataSourceArticle?]
    lazy var saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    private let webView : WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView.init(frame: .zero, configuration: configuration)
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
        if dataSourceArticle.isEmpty{
            navigationItem.setRightBarButton(saveBarButton, animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    //OBJC
    @objc func saveButton(){
        if dataBase.save(articles: self.article){
        showAlertWithSucces(withTitle: "Saved successfully!", withMessage: "")
        }else{
           showAlertWithError(withTitle: "Error save article", withMessage: "try again")
        }
    }
    func showAlertWithSucces(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Continue browsing", style: .cancel, handler: { action in
        })
        let cancel = UIAlertAction(title: "Return to articles", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    func showAlertWithError(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
//extension WebViewViewController{
//    func save(articles:[Articles]) {
//      guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else {
//        return
//      }
//      let managedContext =
//        appDelegate.persistentContainer.viewContext
//
//      let entity =
//        NSEntityDescription.entity(forEntityName: "Article",
//                                   in: managedContext)!
//      let articlesObject = NSManagedObject(entity: entity,
//                                   insertInto: managedContext)
//      saveArticles(articles: articles, object: articlesObject, context: managedContext)
//    }
//}
