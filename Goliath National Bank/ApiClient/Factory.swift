//
//  Factory.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import Foundation

class Factory {

    class func transactions(from json: [[String: AnyObject]]) -> [ProductTransaction] {
        var transactions = [ProductTransaction]()

        for item in json {
            if let transaction = transaction(from: item) {
                transactions.append(transaction)
            }
        }
        return transactions
    }

    private class func transaction(from json: [String: AnyObject]) -> ProductTransaction? {
        if let sku = json["sku"] as? String,
            let amount = json["amount"] as? String,
            let currency = json["currency"] as? String {
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .decimal
            
            var decimalAmount: Decimal = 0
            if let number = formatter.number(from: amount) {
                decimalAmount = number.decimalValue
            }
            return ProductTransaction(sku: sku, amount: decimalAmount, currency: currency)
        } else {
            return nil
        }
    }
    
    class func rates(from json: [[String: AnyObject]]) -> [Rate] {
        var rates = [Rate]()

        for item in json {
            if let rate = rate(from: item) {
                rates.append(rate)
            }
        }
        return rates
    }

    private class func rate(from json: [String: AnyObject]) -> Rate? {
        if let from = json["from"] as? String,
            let to = json["to"] as? String,
            let rate = json["rate"] as? String {
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .decimal
            
            var decimalRate: Decimal = 0
            if let number = formatter.number(from: rate) {
                decimalRate = number.decimalValue
            }
            return Rate(from: from, to: to, rate: decimalRate)
        } else {
            return nil
        }
    }
    
}
