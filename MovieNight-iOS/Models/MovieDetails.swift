import Foundation

struct MovieDetails: Decodable {
    let id: String
    let image: MovieImage
    let runningTimeInMinutes: Int
    let title: String
    let titleType: String
    let year: Int
}

struct MovieImage: Decodable {
    let height: Int
    let id: String
    let url: String
    let width: Int
}
