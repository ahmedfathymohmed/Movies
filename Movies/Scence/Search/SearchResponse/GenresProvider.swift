//
//  GenresProvider.swift
//  Movies
//
//  Created by Ahmed Fathy on 15/06/2026.
//

import Foundation
import Combine

final class GenresProvider {
    static let shared = GenresProvider()

    @Published private(set) var map: [Int: String] = [:]

    private var cancellable: AnyCancellable?

    private init() {
        load()
    }

    func load() {
        guard map.isEmpty else { return }
        let endpoint = MovieEndpoint.genres
        guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { return }
        let publisher: AnyPublisher<GenresResponse, Error> = NetworkManager.shared.request(url: request)
        cancellable = publisher
            .sink { completion in
                if case .failure(let error) = completion {
                }
            } receiveValue: { [weak self] response in
                let pairs = (response.genres ?? []).compactMap { genre -> (Int, String)? in
                    guard let id = genre.id, let name = genre.name else { return nil }
                    return (id, name)
                }
                self?.map = Dictionary(uniqueKeysWithValues: pairs)
            }
    }

    func name(for id: Int) -> String? {
        return map[id]
    }
}
