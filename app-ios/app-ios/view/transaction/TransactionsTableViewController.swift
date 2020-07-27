//
//  TransactionsTableViewController.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit

class TransactionsTableViewController: UITableViewController {

    private var items = [Transaction]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(cell: UITableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.addFooterView()
        
        self.navigationItem.title = "Transações"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlTransactions = URL(string: "http://localhost:8080/transactions")!
        URLSession.shared.transactionsTask(with: urlTransactions) { (transactions, response, error) in
            if let transactions = transactions?.prettyPrinted() {
                print(transactions)
            }
            
            DispatchQueue.main.async {
                self.items = transactions?.data.transaction ?? []
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
        cell.textLabel?.text = item.transactionInformation
        cell.detailTextLabel?.text = "\(item.amount.currency) \(item.amount.amount)"
        return cell
    }

}
