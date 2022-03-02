//
//  WebViewViewController.swift
//  testTask
//
//  Created by Developer on 02.03.2022.
//

import UIKit
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
    private let url : URL
    init(url:URL,title:String){
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    lazy var saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    @objc func saveButton(){
        print("Button work")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
        navigationItem.setRightBarButton(saveBarButton, animated: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
