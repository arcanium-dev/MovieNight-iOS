import Foundation

struct Movie {
    var movieID: String
    var title: String
    var genre: String
    var overview: String
    var releaseDate: Date
    var posterURL: URL?
    
    init(movieID: String, title: String, genre: String, overview: String, releaseDate: Date, posterURL: URL?) {
        self.movieID = movieID
        self.title = title
        self.genre = genre
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterURL = posterURL
    }
}
