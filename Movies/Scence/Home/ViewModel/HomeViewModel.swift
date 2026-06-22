//
//  HomeViewModel.swift
//  Movies App Task
//  Created by Ahmed Fathy on 26/12/2025.
//

import Foundation
import Combine
class HomeViewModel {
    
    // MARK: - Data Sources
    private let categoriesDataSource = ["Popular", "Now Playing", "Upcoming", "Top Rated"]
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    @Published var movies: [Movie] = []
    @Published var displayedMovies: [Movie] = []
    @Published var errorMessage: String?
    
    func fetchMovies(for category: String) {
        let endpoint: MovieEndpoint
        switch category {
            
        case "Popular":
            endpoint = .popular
        case "Now Playing":
            endpoint = .nowPlaying
        case "Upcoming":
            endpoint = .upcoming
        case "Top Rated":
            endpoint = .topRated
        default:
            endpoint = .popular
        }
        
        fetchMovies(endpoint: endpoint)
    }
    // MARK: - API
    func fetchMovies(endpoint: MovieEndpoint) {
        guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { return }
        NetworkManager.shared.request(url: request)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (response: MoviesResponse) in
                self?.movies = response.results
                self?.displayedMovies = response.results
            }
            .store(in: &cancellables)
    }
    private func handleSearch(_ text: String) {
        
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            movies = displayedMovies
            return
        }
        movies = displayedMovies.filter {
            $0.title.lowercased().contains(query.lowercased())
        }
    }
    func bindSearch(textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.handleSearch(text)
            }
            .store(in: &cancellables)
    }
    func getCategoriesCount() -> Int {
        return categoriesDataSource.count
    }
    func getCategory(at index: Int) -> String {
        return categoriesDataSource[index]
    }
    
    func getMovieCount() -> Int {
        return movies.count
    }

    func getMovie(at index: Int) -> Movie {
        return movies[index]
    }
    
}
