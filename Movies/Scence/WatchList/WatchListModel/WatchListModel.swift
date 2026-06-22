//
//  WatchListModel.swift
//  Movies
//
//  Created by Ahmed Fathy on 25/04/2026.
//

import Foundation

struct WatchListModel: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let rating: Double
    let genre: String
    let year: String
    let duration: String
}
