//
//  ApiClientTransactions.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import Foundation

extension APIClient {

    static func transactions(completion: @escaping ([ProductTransaction]?) -> Void) {
        self.get(path: "transactions.json", completion: { response in

            switch response.result {
            case .success(let value):
                if let json = value as? [[String: AnyObject]] {
                    completion(Factory.transactions(from: json))
                }
            case .failure(let error):
                print(error)
            }

        })
    }
}
