//
//  BalanceTableViewController.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit

class BalanceTableViewController: UITableViewController {
    
    private var items = [BalanceElement]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(cell: UITableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.addFooterView()
        
        self.navigationItem.title = "Saldos"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlBalance = URL(string: "http://localhost:8080/balance")!
        URLSession.shared.balanceTask(with: urlBalance) { (balance, response, error) in
            if let balance = balance?.prettyPrinted() {
                print(balance)
            }
            
            DispatchQueue.main.async {
                self.items = balance?.data.balance ?? []
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
        cell.textLabel?.text = "\(item.creditDebitIndicator) / Conta: \(item.accountID)"
        cell.detailTextLabel?.text = "\(item.amount.currency) - \(item.amount.amount)"
        return cell
    }
    
}
