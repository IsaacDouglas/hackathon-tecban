//
//  Balance.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import Foundation

// MARK: - Balance
struct Balance: Codable {
    let data: DataClassBalance
    let links: Links
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case links = "Links"
        case meta = "Meta"
    }
}

// MARK: - DataClass
struct DataClassBalance: Codable {
    let balance: [BalanceElement]

    enum CodingKeys: String, CodingKey {
        case balance = "Balance"
    }
}

// MARK: - BalanceElement
struct BalanceElement: Codable {
    let accountID: String
    let amount: Amount
    let creditDebitIndicator, type, dateTime: String

    enum CodingKeys: String, CodingKey {
        case accountID = "AccountId"
        case amount = "Amount"
        case creditDebitIndicator = "CreditDebitIndicator"
        case type = "Type"
        case dateTime = "DateTime"
    }
}

// MARK: - Amount
struct Amount: Codable {
    let amount, currency: String

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case currency = "Currency"
    }
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func balanceTask(with url: URL, completionHandler: @escaping (Balance?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
