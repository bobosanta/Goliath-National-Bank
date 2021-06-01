//
//  Rate.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import Foundation

class Rate {
    
    let from: String
    let to: String
    let rate: Decimal
    
    init(from: String, to: String, rate: Decimal) {
        self.from = from
        self.to = to
        self.rate = rate
    }
    
}
