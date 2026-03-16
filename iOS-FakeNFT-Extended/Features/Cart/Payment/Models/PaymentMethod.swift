//
//  PaymentMethod.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 15.03.2026.
//

import Foundation
import SwiftUI

struct PaymentMethod: Identifiable, Hashable {
    let id: String
    let title: String
    let code: String
    let image: Image
    
    // Для Hashable
    static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
