
struct DetailResponse: Codable {
    let title: String?
    let overview: String?
    let releaseDate: String?
    let runtime: Int?
    let budget: Int?
    let revenue: Int?
    let status: String?
    let homepage: String?
    let posterPath: String?
    let backdropPath: String?
    let genres: [GenreData]?
    let spokenLanguages: [LanguageData]?
    
    enum CodingKeys: String, CodingKey {
        case title, overview, runtime, budget, revenue, status, homepage, genres
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case spokenLanguages = "spoken_languages"
    }
}

struct GenreData: Codable {
    let id: Int?
    let name: String?
}
struct LanguageData: Codable {
    let name: String?
    let englishName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case englishName = "english_name"
    }
}
