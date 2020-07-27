//
//  Atms.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import Foundation

// MARK: - Atms
struct Atms: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let brand: [Brand]

    enum CodingKeys: String, CodingKey {
        case brand = "Brand"
    }
}

// MARK: - Brand
struct Brand: Codable {
    let brandName: String
    let atm: [ATM]

    enum CodingKeys: String, CodingKey {
        case brandName = "BrandName"
        case atm = "ATM"
    }
}

// MARK: - ATM
struct ATM: Codable {
    let identification: String
    let supportedCurrencies: [SupportedCurrency]
    let location: Location

    enum CodingKeys: String, CodingKey {
        case identification = "Identification"
        case supportedCurrencies = "SupportedCurrencies"
        case location = "Location"
    }
}

// MARK: - Location
struct Location: Codable {
    let site: Site
    let postalAddress: PostalAddress
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case site = "Site"
        case postalAddress = "PostalAddress"
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}

// MARK: - PostalAddress
struct PostalAddress: Codable {
    let addressLine: [String]
    let streetName, townName, postCode: String
    let geoLocation: GeoLocation

    enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case streetName = "StreetName"
        case townName = "TownName"
        case postCode = "PostCode"
        case geoLocation = "GeoLocation"
    }
}

// MARK: - GeoLocation
struct GeoLocation: Codable {
    let geographicCoordinates: GeographicCoordinates

    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
}

// MARK: - GeographicCoordinates
struct GeographicCoordinates: Codable {
    let latitude, longitude: String

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

// MARK: - Site
struct Site: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

enum SupportedCurrency: String, Codable {
    case brl = "BRL"
    case gbp = "GBP"
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

    func atmsTask(with url: URL, completionHandler: @escaping (Atms?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
