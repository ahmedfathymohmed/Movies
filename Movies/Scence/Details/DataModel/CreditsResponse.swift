//
//  CreditsResponse.swift
//  Movies
//
//  Created by Ahmed Fathy on 25/05/2026.
//

import Foundation

struct CreditsResponse: Codable {
    let cast: [CastMember]
}

struct CastMember: Codable {
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
}
