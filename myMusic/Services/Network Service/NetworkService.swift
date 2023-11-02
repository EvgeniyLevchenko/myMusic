//
//  NetworkService.swift
//  myMusic
//
//  Created by QwertY on 13.02.2023.
//

import UIKit
import Alamofire

typealias SearchParameters = [String : Any]

protocol Networking {
    func fetchData<T: Decodable>(searchText: String, of type: T.Type, completion: @escaping (Result<T, AFError>) -> Void)
}

class NetworkService: Networking {
    
    static let shared = NetworkService()
    
    private init() { }
    
    private func getResourseURL<T: Decodable>(for type: T.Type) -> String {
        switch type {
        case is SearchResponse.Type:
            return "https://itunes.apple.com/search"
        default:
            return ""
        }
    }
    
    private func getRequestParameters<T: Decodable>(searchText: String, for type: T.Type) -> SearchParameters {
        switch type {
        case is SearchResponse.Type:
            let parameters = [
                "term" : "\(searchText)",
                "limit" : "15",
                "media" : "music"
            ]
            return parameters
        default:
            return [:]
        }
    }
    
    func fetchData<T>(searchText: String, of type: T.Type, completion: @escaping (Result<T, AFError>) -> Void) where T : Decodable {
        let url = getResourseURL(for: type)
        let paremeters = getRequestParameters(searchText: searchText, for: type)
        
        AF.request(url, method: .get, parameters: paremeters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: type) { response in
            completion(response.result)
        }
    }
}
