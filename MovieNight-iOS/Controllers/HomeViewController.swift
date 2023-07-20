import UIKit
import UIImageColors
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var thirdCardImageView: UIImageView!
    @IBOutlet weak var secondCardImageView: UIImageView!
    @IBOutlet weak var firstCardImageView: UIImageView!
    private var gradientLayer: CAGradientLayer?
    private var cardIndex = 0
    private var initialCardCenter: CGPoint = .zero
    var movieManager = MovieManager()
    var movieIdsList: MovieIds?
    let movieCardArray = [#imageLiteral(resourceName: "Image 4"), #imageLiteral(resourceName: "Image 2"), #imageLiteral(resourceName: "Image 5"), #imageLiteral(resourceName: "Image 1"), #imageLiteral(resourceName: "Image 3"), #imageLiteral(resourceName: "doctorStrange"), #imageLiteral(resourceName: "Image")]
        var moviesList: [MovieDetails]?
        //set initial batch number (top 250 movies divided into 5 batches of 50)
        var batchPage = 1
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateCardImages()
            movieManager.delegate = self
            movieManager.fetchMovies(pageNo: batchPage)
            setUpComponents()
            setUpGestureRecognizers()
        }
        
        
        func setUpComponents() {

            if let firstImage = movieCardArray.first {
                firstCardImageView.image = firstImage
                updateGradientBackground()
            }

            createDefaultBackground()

            // Create movieCardImageView programmatically
            configureImageView(firstCardImageView)
            configureImageView(thirdCardImageView)
            configureImageView(secondCardImageView)

            updateCardImages()
        }

    
    func configureImageView(_ imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.center = view.center
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    private func createDefaultBackground() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - (tabBarController?.tabBar.frame.height ?? 0) )
        
        if let gradientLayer = gradientLayer {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func updateCardImages() {
        //check movies list not null
            if let listOfMovies = moviesList {
                //if index is larger than list of movies switch to next batch
                if cardIndex > (listOfMovies.count - 1) {
                    //currently max 5 batches so loop back to batch 1 after we exhaust all batches
                    if batchPage == 5 {
                        batchPage = 1
                    } else {
                        batchPage += 1
                    }
                    //start from index 0 of new batch and replace the exhausted movies list with new movies list
                    cardIndex = 0
                    movieManager.fetchMovies(pageNo: batchPage)
                }
                //load 3 images at a time
                let firstImage = listOfMovies[cardIndex]
                let secondImage = listOfMovies[(cardIndex + 1) % (listOfMovies.count)]
                let thirdImage = listOfMovies[(cardIndex + 2) % (listOfMovies.count)]
                
                firstCardImageView.sd_setImage(with: URL(string: firstImage.primaryImage.url), placeholderImage: #imageLiteral(resourceName: "Loading"))
                thirdCardImageView.sd_setImage(with: URL(string: secondImage.primaryImage.url), placeholderImage: #imageLiteral(resourceName: "Loading"))
                secondCardImageView.sd_setImage(with: URL(string: thirdImage.primaryImage.url), placeholderImage: #imageLiteral(resourceName: "Loading"))
                
            } else {
                firstCardImageView.image =  #imageLiteral(resourceName: "Loading")
                thirdCardImageView.image =  #imageLiteral(resourceName: "Loading")
                secondCardImageView.image =  #imageLiteral(resourceName: "Loading")
            }
            
            // Set initial positions for the next cards
            thirdCardImageView.center = CGPoint(x: firstCardImageView.center.x, y: firstCardImageView.center.y - 10)
            secondCardImageView.center = CGPoint(x: firstCardImageView.center.x, y: firstCardImageView.center.y - 20)
        }

    
    
    private func updateGradientBackground() {
        guard let image = firstCardImageView.image else { return }
        
        // Create a higher-quality image representation
        let size = CGSize(width: view.bounds.width * 2, height: view.bounds.height * 2)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let highQualityImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        
        highQualityImage.getColors { [weak self] colors in
            DispatchQueue.main.async {
                guard let colors = colors else { return }
                self?.gradientLayer?.colors = [colors.background.cgColor,
                                               colors.primary.cgColor,
                                               colors.background.cgColor]
            }
        }
    }
    
    func nextCardImage() {
            if let listOfMovies = moviesList {
                cardIndex = (cardIndex + 1)
                firstCardImageView.sd_setImage(with: URL(string: listOfMovies[cardIndex % (listOfMovies.count)].primaryImage.url), placeholderImage: #imageLiteral(resourceName: "Loading"))
                updateGradientBackground()
            }
        }
    
    private func setUpGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        firstCardImageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let card = gestureRecognizer.view else { return }
        
        switch gestureRecognizer.state {
        case .began:
            initialCardCenter = card.center
        case .changed:
            let translation = gestureRecognizer.translation(in: view)
            card.center = CGPoint(x: initialCardCenter.x + translation.x, y: initialCardCenter.y + translation.y)
            let screenWidth = view.bounds.width
            let rotationStrength = min(translation.x / (screenWidth / 2), 1)
            let rotationAngle = CGFloat.pi / 8 * rotationStrength
            let transform = CGAffineTransform(rotationAngle: rotationAngle)
            card.transform = transform
            // Adjust position of the first card only
            let cardTranslationX = card.center.x - initialCardCenter.x
            card.center.x = initialCardCenter.x + cardTranslationX
        case .ended:
            // Determine if the card was swiped to the left or right
            let translation = gestureRecognizer.translation(in: view)
            let velocity = gestureRecognizer.velocity(in: view)
            let threshold: CGFloat = 100
            let shouldDismiss = abs(translation.x) > threshold || abs(velocity.x) > threshold
            
            if shouldDismiss {
                // Card was swiped, animate offscreen
                let destinationX = translation.x > 0 ? view.bounds.width + card.bounds.width : -view.bounds.width - card.bounds.width
                UIView.animate(withDuration: 0.3, animations: {
                    card.center.x = destinationX
                }) { _ in
                    self.nextCardImage()
                    // Reset card position
                    card.center = self.initialCardCenter
                    card.transform = .identity
                    
                    self.updateCardImages()
                }
            } else {
                // Card was not swiped, animate back to initial position
                UIView.animate(withDuration: 0.3) {
                    card.center = self.initialCardCenter
                    card.transform = .identity
                    self.thirdCardImageView.center = self.initialCardCenter
                    self.secondCardImageView.center = self.initialCardCenter
                }
            }
        default:
            break
        }
    }
}

//MARK: - Movies Delegates

extension HomeViewController: MovieManagerDelegate {
    func didUpdateMovieList(_ movieManager: MovieManager, _ movieList: [MovieDetails]) {
        DispatchQueue.main.async {
            //Do functions here e.g get image and display
            self.moviesList = movieList
            self.updateCardImages()
        }
    }
    
    func didFailWithError(_ error: Error) {
    }
    
    
}
