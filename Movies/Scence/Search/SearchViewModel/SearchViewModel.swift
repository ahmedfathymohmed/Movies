import Foundation
import Combine

class SearchViewModel {

    @Published var movies: [WatchListModel] = []
    @Published var state: SearchState = .empty
    private var rawResults: [Movie] = []
    private var runtimeByID: [Int: Int] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var detailCancellables = Set<AnyCancellable>()

    enum SearchState {
        case empty
        case loading
        case results
        case noResults
    }

    init() {
        GenresProvider.shared.$map
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.mapResults()
            }
            .store(in: &cancellables)
    }

    func bindSearch(textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard !text.isEmpty else {
                    self?.state = .empty
                    self?.rawResults = []
                    self?.movies = []
                    return
                }
                self?.searchMovies(query: text)
            }
            .store(in: &cancellables)
    }

    private func searchMovies(query: String) {
        state = .loading

        let endpoint = MovieEndpoint.search(query: query)
        guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { return }

        let publisher: AnyPublisher<SearchResponse, Error> = NetworkManager.shared.request(url: request)
        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.rawResults = response.results ?? []
                self.runtimeByID = [:]
                self.detailCancellables.removeAll()
                self.mapResults()
                self.state = self.rawResults.isEmpty ? .noResults : .results
                self.fetchRuntimes(for: self.rawResults)
            }
            .store(in: &cancellables)
    }

    private func fetchRuntimes(for movies: [Movie]) {
        for movie in movies {
            let endpoint = MovieEndpoint.details(id: movie.id)
            guard let request = APIBuilder.buildRequest(endpoint: endpoint) else { continue }
            let publisher: AnyPublisher<DetailResponse, Error> = NetworkManager.shared.request(url: request)
            publisher
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { [weak self] detail in
                    guard let self = self, let runtime = detail.runtime else { return }
                    self.runtimeByID[movie.id] = runtime
                    self.mapResults()
                }
                .store(in: &detailCancellables)
        }
    }

    private func mapResults() {
        let genres = GenresProvider.shared.map
        movies = rawResults.map { movie in
            let duration = runtimeByID[movie.id].map { "\($0) minutes" } ?? ""
            return WatchListModel(
                id: movie.id,
                title: movie.title,
                posterPath: movie.posterPath,
                rating: movie.voteAverage,
                genre: movie.genreIDs.first.flatMap { genres[$0] } ?? "",
                year: String(movie.releaseDate.prefix(4)),
                duration: duration
            )
        }
    }
    
    func getMovieCount() -> Int {
        return movies.count
    }
    
    func getMovie(at index: Int) -> WatchListModel {
        return movies[index]
    }
}
