//
//  ImageLoader.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 11/01/2026.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    
    private init() {}
    
    func loadImage(from path: String) async -> UIImage? {
        
        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        
        if let cached = cache.object(forKey: urlString as NSString) {
            return cached
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return nil }
            
            cache.setObject(image, forKey: urlString as NSString)
            
            return image
        } catch {
            
            return nil
            
        }
        
    }
    
}
