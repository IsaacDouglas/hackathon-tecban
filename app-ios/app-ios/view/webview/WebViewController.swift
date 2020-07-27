//
//  WebViewController.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        config.userContentController = userContentController
        return WKWebView(frame: .zero, configuration: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

        let layoutGuide = view.safeAreaLayoutGuide
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        webView.navigationDelegate = self
        
        self.navigationItem.title = "Consentimento"
        
        let backbutton = UIButton(type: .custom)
        backbutton.setTitle("Voltar", for: .normal)
        backbutton.setTitleColor(navigationController?.navigationBar.tintColor, for: .normal)
        backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    
    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/consentimento")!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let url = String(data: data, encoding: .utf8)!
            self.load(url: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed))
            print(url)
        }
        task.resume()
    }

    private func load(url: String?) {
        guard
            let link = url,
            let url = URL(string: link)
        else { return }
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let code = url?.absoluteString.getQueryStringParameter("code") {
            print(code)
            decisionHandler(.cancel)
            self.dismiss(animated: true, completion: nil)
        } else {
            decisionHandler(.allow)
        }
    }
}
