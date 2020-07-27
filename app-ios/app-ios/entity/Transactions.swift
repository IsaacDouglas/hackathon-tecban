//
//  Transactions.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import Foundation

// MARK: - Transactions
struct Transactions: Codable {
    let data: DataClassTransaction
    let links: Links
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case links = "Links"
        case meta = "Meta"
    }
}


// MARK: - DataClass
struct DataClassTransaction: Codable {
    let transaction: [Transaction]

    enum CodingKeys: String, CodingKey {
        case transaction = "Transaction"
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let accountID: String
    let bookingDateTime, valueDateTime, transactionInformation, transactionID: String
    let amount: AmountTransaction
    let creditDebitIndicator: CreditDebitIndicator
    let status: Status
    let merchantDetails: MerchantDetails
    let transactionMutability: TransactionMutability
    let transactionReference: String
    let bankTransactionCode: BankTransactionCode
    let balance: BalanceTransaction

    enum CodingKeys: String, CodingKey {
        case accountID = "AccountId"
        case bookingDateTime = "BookingDateTime"
        case valueDateTime = "ValueDateTime"
        case transactionInformation = "TransactionInformation"
        case transactionID = "TransactionId"
        case amount = "Amount"
        case creditDebitIndicator = "CreditDebitIndicator"
        case status = "Status"
        case merchantDetails = "MerchantDetails"
        case transactionMutability = "TransactionMutability"
        case transactionReference = "TransactionReference"
        case bankTransactionCode = "BankTransactionCode"
        case balance = "Balance"
    }
}

// MARK: - Amount
struct AmountTransaction: Codable {
    let amount: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case currency = "Currency"
    }
}

// MARK: - Balance
struct BalanceTransaction: Codable {
    let amount: AmountTransaction
    let creditDebitIndicator: CreditDebitIndicator
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case creditDebitIndicator = "CreditDebitIndicator"
        case type = "Type"
    }
}

enum CreditDebitIndicator: String, Codable {
    case credit = "Credit"
    case debit = "Debit"
}

enum TypeEnum: String, Codable {
    case closingAvailable = "ClosingAvailable"
}

// MARK: - BankTransactionCode
struct BankTransactionCode: Codable {
    let code: Code
    let subCode: SubCode

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case subCode = "SubCode"
    }
}

enum Code: String, Codable {
    case customerCardTransactions = "CustomerCardTransactions"
}

enum SubCode: String, Codable {
    case cashWithdrawal = "CashWithdrawal"
}

// MARK: - MerchantDetails
struct MerchantDetails: Codable {
}

enum Status: String, Codable {
    case booked = "Booked"
}

enum TransactionMutability: String, Codable {
    case mutable = "Mutable"
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

    func transactionsTask(with url: URL, completionHandler: @escaping (Transactions?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
