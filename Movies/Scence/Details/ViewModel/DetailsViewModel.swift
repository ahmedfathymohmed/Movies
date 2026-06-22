//
//  DetailsViewModel.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 24/01/2026.
//

import Foundation
import Combine

class DetailsViewModel {
    
    // MARK: - Properties
    private let movieId: Int
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var detailResponse: DetailResponse?
    @Published private(set) var reviews: [ReviewItem] = []
    @Published private(set) var cast: [CastMember] = []

    let tabs = ["About Movie", "Reviews", "Cast"]
    private(set) var selectedIndex = 0
    
    @Published private(set) var errorMessage: String?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func fetchMoviesDetails() {
        let endpoint = MovieEndpoint.details(id: movieId)
        guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { return }
        
        NetworkManager.shared.request(url: request)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (response: DetailResponse) in
                self?.detailResponse = response
            }
            .store(in: &cancellables)
    }
    func fetchMovieReviews() {
        let endpoint = MovieEndpoint.reviews(id: movieId)
        guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { return }
        
        let publisher: AnyPublisher<ReviewsResponse, Error> = NetworkManager.shared.request(url: request)
        publisher
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                DispatchQueue.main.async {
                    self?.reviews = response.results ?? []
                }
            }
            .store(in: &cancellables)
    }
    func fetchMovieCredits() {
        let endpoint = MovieEndpoint.credits(id: movieId)
        guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { return }
        
        let publisher: AnyPublisher<CreditsResponse, Error> = NetworkManager.shared.request(url: request)
        publisher
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.cast = response.cast
            }
            .store(in: &cancellables)
    }
}
