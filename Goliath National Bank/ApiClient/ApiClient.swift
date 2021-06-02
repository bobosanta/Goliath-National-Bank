//
//  ApiClient.swift
//  Goliath National Bank
//
//  Created by Bogdan on 01.06.2021.
//

import Foundation
import Alamofire

class APIClient {

    static func get(path: String, params: [String: Any]? = nil, completion: @escaping (_ json: DataResponse<Any, AFError>) -> Void) {
        performRequest(path: path, method: .get, params: params, completion: completion)
    }

    // MARK: Private
    private static func performRequest(path: String, method: HTTPMethod, params: [String: Any]?, encoding: ParameterEncoding = URLEncoding.default, completion: @escaping (_ response: DataResponse<Any, AFError>) -> Void) {

        var requestParams = [String: Any]()

        if let p = params {
            requestParams = p
        }
        AF.request(urlFromString(path),
            method: method,
            parameters: requestParams,
            encoding: encoding,
            headers: ["Accept": "text/html"]).validate().responseJSON { (response) in
            completion(response)
        }
    }

    // MARK: - Helpers
    internal static func urlFromString(_ string: String) -> String {
        return "http://gnb.dev.airtouchmedia.com/" + string
    }
}
