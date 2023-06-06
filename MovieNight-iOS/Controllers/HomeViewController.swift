import UIKit
import FirebaseAuth
import Foundation
class HomeViewController: UIViewController {
    
    var movieManager = MovieManager()
    var movieIdsList: MovieIds?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        movieManager.fetchMovies()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController (title: nil,
                                                 message: "Are you sure you want to sign out?",
                                                 preferredStyle: .actionSheet)
        alertController.addAction (
            UIAlertAction (
                title: "Sign Out",
                style: .destructive,
                handler: { (_) in self.signOut()}
            )
        )
        alertController.addAction (UIAlertAction (title: "Cancel", style: .cancel, handler: nil))
        present (alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.showAuthScreen()
            }
        } catch let error {
            print("Failed to sign out", error)
        }
    }
}

//MARK: - Movies Delegates

extension HomeViewController: MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, _ movieDetails: MovieDetails) {
        DispatchQueue.main.async {
            //Do functions here e.g get image and display
            print(movieDetails.title)
        }
    }
    
    func didUpdateMovieList(_ movieManager: MovieManager, _ movieIds: MovieIds) {
        DispatchQueue.main.async {
            //Gets list of movie codes in format "/title/ttxxxxxxx/ and loads the first one in the queue up"
            self.movieIdsList = movieIds
            let idCode = movieIds.Ids[0].components(separatedBy: "/")[2]
            movieManager.fetchMovieDetails(movieId: idCode)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}
