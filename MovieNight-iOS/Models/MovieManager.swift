import Foundation
import CoreLocation

protocol MovieManagerDelegate {
    func didUpdateMovieList(_ movieManager: MovieManager, _ movieList: [MovieDetails])
    func didFailWithError(_ error: Error)
}

struct MovieManager {
    let BaseUrl = "https://moviesdatabase.p.rapidapi.com/titles?list=top_rated_250&sort=year.decr&info=mini_info&limit=50&page="
    
    var delegate: MovieManagerDelegate?
    
    func fetchMovies(pageNo: Int){
        let getPopularUrl = "\(BaseUrl)\(pageNo)"
        if let url = URL(string: getPopularUrl) {
            
            var request = URLRequest(url: url)
            request.addValue("da482c636amsh1c83faeef7ae0a7p1b04f7jsn6fd0f7cb9c36", forHTTPHeaderField: "X-RapidAPI-Key")
            request.addValue("moviesdatabase.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
            
            //Perform Request
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(APIOverview.self, from: data)
                        let movieDetails = decodedData.results
                        self.delegate?.didUpdateMovieList(self, movieDetails)
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
}
