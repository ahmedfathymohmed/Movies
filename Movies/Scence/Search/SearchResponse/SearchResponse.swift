//
//  SearchResponse.swift
//  Movies
//
//  Created by Ahmed Fathy on 14/06/2026.
//


// SearchResponse.swift
import Foundation

struct SearchResponse: Codable {
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages   = "total_pages"
        case totalResults = "total_results"
    }
}
