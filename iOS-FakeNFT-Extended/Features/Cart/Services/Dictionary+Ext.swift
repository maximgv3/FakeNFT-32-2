//
//  Dictionary+Ext.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 24.03.2026.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    /// Кодирует словарь в тело `application/x-www-form-urlencoded`
    func percentEncoded() -> Data? {
        let query = self.map { key, value in
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
            return "\(key)=\(encodedValue)"
        }.joined(separator: "&")
        return query.data(using: .utf8)
    }
}
