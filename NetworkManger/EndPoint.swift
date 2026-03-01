//
//  EndPoint.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 24/01/2026.
//


import Foundation

enum MovieEndpoint {
    case popular
    case details(id: Int)
    case nowPlaying
    case upcoming
    case topRated
}
extension MovieEndpoint {
    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .details(let id):
            return "/movie/\(id)"
        case .nowPlaying:
            return "/movie/now_playing"
        case .upcoming:
            return "/movie/upcoming"
        case .topRated:
            return "/movie/top_rated"
        }
    }
}
