//
//  APIClientRates.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import Foundation

extension APIClient {

    static func rates(completion: @escaping ([Rate]?) -> Void) {
        self.get(path: "rates.json", completion: { response in

            switch response.result {
            case .success(let value):
                if let json = value as? [[String: AnyObject]] {
                    completion(Factory.rates(from: json))
                }
            case .failure(let error):
                print(error)
            }

        })
    }
    
}
