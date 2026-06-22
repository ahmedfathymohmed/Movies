//
//  WatchListStorage.swift
//  Movies
//
//  Created by Ahmed Fathy on 25/04/2026.
//

import Foundation

class WatchListStorage {
    
    private let key = "watchlist_movies"
    
    func getMovies() -> [WatchListModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let movies = try? JSONDecoder().decode([WatchListModel].self, from: data)
        else {
            return []
        }
        return movies
    }
    
    func save(movie: WatchListModel) {
        var movies = getMovies()
        
        if !movies.contains(where: { $0.id == movie.id }) {
            movies.append(movie)
        }
        
        let data = try? JSONEncoder().encode(movies)
        UserDefaults.standard.set(data, forKey: key)
    }
    func remove(movieId: Int) {
        var movies = getMovies()
        movies.removeAll { $0.id == movieId }
        
        let data = try? JSONEncoder().encode(movies)
        UserDefaults.standard.set(data, forKey: key)
    }
    
}
