//
//  NetworkManaging.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 19/01/2026.
//

import Foundation
import Combine

protocol NetworkManaging {
    
    func request<T: Decodable>(url: URLRequest) -> AnyPublisher<T, Error>
}
