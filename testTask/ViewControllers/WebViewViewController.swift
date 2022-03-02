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
    private let webView : WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView.init(frame: .zero, configuration: configuration)
        return webView
    }()
    var article : [Articles]
    var dataSourceArticle : [DataSourceArticle?]
    private let url : URL
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
    lazy var saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    @objc func saveButton(){
        save(articles: self.article)
        dismiss(animated: true, completion: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
}
extension WebViewViewController{
    func save(articles:[Articles]) {
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext =
        appDelegate.persistentContainer.viewContext

      let entity =
        NSEntityDescription.entity(forEntityName: "Article",
                                   in: managedContext)!
      let articlesObject = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      saveArticles(articles: articles, object: articlesObject, context: managedContext)
    }
}
