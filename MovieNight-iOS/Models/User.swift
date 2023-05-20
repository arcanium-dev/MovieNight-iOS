import Foundation

struct User {
    var userID: String
    var email: String
    var favoriteGenres: [String]
    
    init(userID: String, email: String, favoriteGenres: [String]) {
        self.userID = userID
        self.email = email
        self.favoriteGenres = favoriteGenres
    }
}
