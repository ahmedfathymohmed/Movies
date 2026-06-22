//
//  ReviewsResponse.swift
//  Movies
//
//  Created by Ahmed Fathy on 20/05/2026.
//

import Foundation
// MARK: - MovieReviewsResponse
struct ReviewsResponse: Codable {
    let results: [ReviewItem]?
}

// MARK: - ReviewItem
struct ReviewItem: Codable {
    let author: String?
    let content: String?
    let authorDetails: AuthorDetails?
    
    enum CodingKeys: String, CodingKey {
        case author, content
        case authorDetails = "author_details"
    }
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let username: String?
    let avatarPath: String?
    let rating: Double?          
    
    enum CodingKeys: String, CodingKey {
        case username, rating
        case avatarPath = "avatar_path"
    }
}
