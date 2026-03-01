//
//  APIBuilder.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 19/01/2026.
//

import Foundation

struct APIBuilder {
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYzQxZjZkYzcxNjhkNWFiMjE2NGVkOWQxNmNmZTI4NiIsIm5iZiI6MTQ1MzkyNzM5MC40NjUsInN1YiI6IjU2YTkyYmRlYzNhMzY4NzJkMzAwMTc2MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ecy-T7m8SWpthLlxrtJ8UZswr-hWcfnnF9ykD5WjKCY"
    
    static func buildRequest(endpoint: MovieEndpoint) -> URLRequest? {
        let urlString = baseURL + endpoint.path
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

