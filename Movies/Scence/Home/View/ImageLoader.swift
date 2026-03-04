//
//  ImageLoader.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 11/01/2026.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {}
    
    func loadImage(from path: String) async -> UIImage? {
        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        
        guard let url = URL(string: urlString) else { return nil }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data:data)
        } catch {
            return nil
        }
    }
}
