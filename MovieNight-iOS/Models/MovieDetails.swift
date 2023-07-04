import Foundation

struct APIOverview: Decodable {
    let page: String
    let next: String
    let entries: Int
    let results: [MovieDetails]
}

struct MovieDetails: Decodable {
    let id: String
    let primaryImage: MovieImage
    let originalTitleText: MovieTitle
    let releaseDate: MovieReleaseDate
}

struct MovieImage: Decodable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let caption: MovieCaption
}

struct MovieTitle: Decodable {
    let text: String
}

struct MovieReleaseDate: Decodable {
    let day: Int
    let month: Int
    let year: Int
}

struct MovieCaption: Decodable {
    let plainText: String
}
