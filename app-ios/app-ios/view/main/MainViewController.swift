//
//  MainViewController.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let urlAtms = URL(string: "http://localhost:8080/atms")!
        //        URLSession.shared.atmsTask(with: urlAtms) { (atms, response, error) in
        //            if let atms = atms?.prettyPrinted() {
        //                print(atms)
        //            }
        //        }.resume()
        
        let button = UIBarButtonItem(title: "Consentimento", style: .plain, target: self, action: #selector(consentimento))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func consentimento() {
        let web = WebViewController()
        let navigation = UINavigationController(rootViewController: web)
        self.present(navigation, animated: true, completion: nil)
    }

}
