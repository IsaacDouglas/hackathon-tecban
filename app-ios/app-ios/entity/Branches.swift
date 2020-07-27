//
//  Branches.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import Foundation

// MARK: - Branches
struct Branches: Codable {
    let data: [DatumBranch]
}

// MARK: - Datum
struct DatumBranch: Codable {
    let brand: [BrandBranch]

    enum CodingKeys: String, CodingKey {
        case brand = "Brand"
    }
}

// MARK: - Brand
struct BrandBranch: Codable {
    let brandName: String
    let branch: Branch

    enum CodingKeys: String, CodingKey {
        case brandName = "BrandName"
        case branch = "Branch"
    }
}

// MARK: - Branch
struct Branch: Codable {
    let accessibility: [String]
    let availability: Availability
    let customerSegment: [String]
    let identification, name: String
    let contactInfo: [ContactInfo]
    let photo: String
    let postalAddress: PostalAddress
    let sequenceNumber: String
    let serviceAndFacility: [String]
    let type: String
    let sortCode: [String]

    enum CodingKeys: String, CodingKey {
        case accessibility = "Accessibility"
        case availability = "Availability"
        case customerSegment = "CustomerSegment"
        case identification = "Identification"
        case name = "Name"
        case contactInfo = "ContactInfo"
        case photo = "Photo"
        case postalAddress = "PostalAddress"
        case sequenceNumber = "SequenceNumber"
        case serviceAndFacility = "ServiceAndFacility"
        case type = "Type"
        case sortCode = "SortCode"
    }
}

// MARK: - Availability
struct Availability: Codable {
    let standardAvailability: StandardAvailability

    enum CodingKeys: String, CodingKey {
        case standardAvailability = "StandardAvailability"
    }
}

// MARK: - StandardAvailability
struct StandardAvailability: Codable {
    let day: [Day]

    enum CodingKeys: String, CodingKey {
        case day = "Day"
    }
}

// MARK: - Day
struct Day: Codable {
    let name: String
    let openingHours: [OpeningHour]

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case openingHours = "OpeningHours"
    }
}

// MARK: - OpeningHour
struct OpeningHour: Codable {
    let closingTime, openingTime: String

    enum CodingKeys: String, CodingKey {
        case closingTime = "ClosingTime"
        case openingTime = "OpeningTime"
    }
}

// MARK: - ContactInfo
struct ContactInfo: Codable {
    let contactType, contactContent: String

    enum CodingKeys: String, CodingKey {
        case contactType = "ContactType"
        case contactContent = "ContactContent"
    }
}

// MARK: - PostalAddress
struct PostalAddressBranch: Codable {
    let addressLine: [String]
    let buildingNumber, country: String
    let countrySubDivision: [String]
    let geoLocation: GeoLocationBranch
    let postCode, streetName, townName: String

    enum CodingKeys: String, CodingKey {
        case addressLine = "AddressLine"
        case buildingNumber = "BuildingNumber"
        case country = "Country"
        case countrySubDivision = "CountrySubDivision"
        case geoLocation = "GeoLocation"
        case postCode = "PostCode"
        case streetName = "StreetName"
        case townName = "TownName"
    }
}


// MARK: - GeoLocation
struct GeoLocationBranch: Codable {
    let geographicCoordinates: GeographicCoordinatesBranch

    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
}


// MARK: - GeographicCoordinates
struct GeographicCoordinatesBranch: Codable {
    let latitude, longitude: String

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
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

    func branchesTask(with url: URL, completionHandler: @escaping (Branches?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
