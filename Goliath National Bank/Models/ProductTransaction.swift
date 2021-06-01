//
//  ProductTransaction.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import Foundation

class ProductTransaction: Codable {
    
    let sku: String
    let amount: Decimal
    let currency: String
    
    init(sku: String, amount: Decimal, currency: String) {
        self.sku = sku
        self.amount = amount
        self.currency = currency
    }
    
}
