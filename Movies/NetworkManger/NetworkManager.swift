//
//  NetworkManager.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 26/12/2025.
//
import Foundation
import Combine
    
class NetworkManager: NetworkManaging {
        
        static let shared = NetworkManager()
        private init() {}
    
        func request<T: Decodable>(url: URLRequest) -> AnyPublisher<T, Error> {
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
