//
//  Account.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import Foundation

// MARK: - Account
struct Account: Codable {
    let data: DataClassAccount
    let links: Links
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case links = "Links"
        case meta = "Meta"
    }
}

// MARK: - DataClass
struct DataClassAccount: Codable {
    let account: [DataAccount]

    enum CodingKeys: String, CodingKey {
        case account = "Account"
    }
}

// MARK: - DataAccount
struct DataAccount: Codable {
    let accountID, currency, nickname, accountType: String
    let accountSubType: String
    let account: [AccountAccount]

    enum CodingKeys: String, CodingKey {
        case accountID = "AccountId"
        case currency = "Currency"
        case nickname = "Nickname"
        case accountType = "AccountType"
        case accountSubType = "AccountSubType"
        case account = "Account"
    }
}

// MARK: - AccountAccount
struct AccountAccount: Codable {
    let schemeName, name, identification: String

    enum CodingKeys: String, CodingKey {
        case schemeName = "SchemeName"
        case name = "Name"
        case identification = "Identification"
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "Self"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case totalPages = "TotalPages"
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

    func accountTask(with url: URL, completionHandler: @escaping (Account?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
