//
//  TabBarController.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainNavigation = UINavigationController(rootViewController: MainViewController())
        mainNavigation.tabBarItem = UITabBarItem(title: "UN", image: nil, selectedImage: nil)
        
        let balance = BalanceTableViewController()
        balance.tabBarItem = UITabBarItem(title: "Saldos", image: nil, selectedImage: nil)
        
        let account = AccountTableViewController()
        account.tabBarItem = UITabBarItem(title: "Contas", image: nil, selectedImage: nil)
        
        let transactions = TransactionsTableViewController()
        transactions.tabBarItem = UITabBarItem(title: "Transações", image: nil, selectedImage: nil)
        
        self.viewControllers = [mainNavigation,
                                balance,
                                account,
                                transactions]
        
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .black
    }
}
