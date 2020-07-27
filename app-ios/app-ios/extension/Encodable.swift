//
//  Encodable.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import Foundation

extension Encodable {
    func prettyPrinted() -> String? {
        return isPrettyPrinted(true)
    }

    func encode() -> String? {
        return isPrettyPrinted(false)
    }

    private func isPrettyPrinted(_ value: Bool) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = value ? .prettyPrinted : .init(rawValue: 0)
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
