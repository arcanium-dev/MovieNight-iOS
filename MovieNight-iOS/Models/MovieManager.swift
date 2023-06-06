import Foundation
import CoreLocation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, _ movieDetails: MovieDetails)
    func didUpdateMovieList(_ movieManager: MovieManager, _ movieIds: MovieIds)
    func didFailWithError(_ error: Error)
}

struct MovieManager {
    let getPopularUrl = "https://online-movie-database.p.rapidapi.com/title/get-most-popular-movies"
    let getDetailsUrl = "https://online-movie-database.p.rapidapi.com/title/get-details"
    
    var delegate: MovieManagerDelegate?
    
    func fetchMovies(){
        if let url = URL(string: getPopularUrl) {
            
            var request = URLRequest(url: url)
            request.addValue("25a6c0276emsh23c8759e27a78a2p1ead41jsn754386ffecae", forHTTPHeaderField: "X-RapidAPI-Key")
            request.addValue("online-movie-database.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
            
            //Perform Request
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([String].self, from: data)
                        let movieIds = MovieIds(Ids: decodedData)
                        self.delegate?.didUpdateMovieList(self, movieIds)
                    } catch {
                        delegate?.didFailWithError(error)
                        print(String(describing: error))
                        return
                    }
                }
            }
            dataTask.resume()
        } else {
            print("error in fetch movies request")
        }
    }
    
    
    func fetchMovieDetails(movieId: String){
        //Build Url
        var urlComponent = URLComponents(string: getDetailsUrl)!
        urlComponent.queryItems = [
            URLQueryItem(name: "tconst", value: movieId)
        ]
        if let url = urlComponent.url {
            var request = URLRequest(url: url)
            request.addValue("25a6c0276emsh23c8759e27a78a2p1ead41jsn754386ffecae", forHTTPHeaderField: "X-RapidAPI-Key")
            request.addValue("online-movie-database.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
            
            //Perform Request
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(MovieDetails.self, from: data) as MovieDetails
                        let movieDetails = decodedData
                        self.delegate?.didUpdateMovie(self, movieDetails)
                    } catch {
                        print(String(describing: error))
                    }
                }
            }
            dataTask.resume()
        } else {
            print("error in fetch movies details request")
        }
    }
}
