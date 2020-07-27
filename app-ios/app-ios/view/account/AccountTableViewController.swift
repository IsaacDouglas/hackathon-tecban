//
//  AccountTableViewController.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    private var items = [DataAccount]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(cell: UITableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.addFooterView()
        
        self.navigationItem.title = "Contas e cartões"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlAccount = URL(string: "http://localhost:8080/account")!
        URLSession.shared.accountTask(with: urlAccount) { (account, response, error) in
            if let account = account?.prettyPrinted() {
                print(account)
            }
            
            DispatchQueue.main.async {
                self.items = account?.data.account ?? []
            }
        }.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.identifier)
        let item = items[indexPath.row]
        cell.textLabel?.text = "\(item.accountType) / \(item.accountSubType)"
        cell.detailTextLabel?.text = "\(item.nickname) - \(item.currency)"
        return cell
    }

}
