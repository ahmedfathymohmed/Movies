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
}
