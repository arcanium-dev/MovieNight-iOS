import UIKit
import UIImageColors

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nextCard1ImageView: UIImageView!
    @IBOutlet weak var nextCard2ImageView: UIImageView!
    @IBOutlet weak var movieCardImageView: UIImageView!
    private var gradientLayer: CAGradientLayer?
    private var currentIndex = 0
    private var initialCardCenter: CGPoint = .zero
    var movieManager = MovieManager()
    var movieIdsList: MovieIds?
    
    let movieCardArray = [#imageLiteral(resourceName: "Image 4"), #imageLiteral(resourceName: "Image 2"), #imageLiteral(resourceName: "Image 5"), #imageLiteral(resourceName: "Image 1"), #imageLiteral(resourceName: "Image 3"), #imageLiteral(resourceName: "doctorStrange"), #imageLiteral(resourceName: "Image")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
        setUpGestureRecognizers()
        movieManager.delegate = self
        movieManager.fetchMovies()
    }
    
    
    func setUpComponents() {
        
        if let firstImage = movieCardArray.first {
            movieCardImageView.image = firstImage
            updateGradientBackground()
        }
        
        createDefaultBackground()
        
        // Create movieCardImageView programmatically
        movieCardImageView.translatesAutoresizingMaskIntoConstraints = false
        movieCardImageView.center = view.center
        movieCardImageView.layer.cornerRadius = 10
        movieCardImageView.clipsToBounds = true
        
        nextCard1ImageView.translatesAutoresizingMaskIntoConstraints = false
        nextCard1ImageView.center = view.center
        nextCard1ImageView.layer.cornerRadius = 10
        nextCard1ImageView.clipsToBounds = true
        
        nextCard2ImageView.translatesAutoresizingMaskIntoConstraints = false
        nextCard2ImageView.center = view.center
        nextCard2ImageView.layer.cornerRadius = 10
        nextCard2ImageView.clipsToBounds = true
        
        updateCardImages()
    }
    
    private func createDefaultBackground() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - (tabBarController?.tabBar.frame.height ?? 0) )
        
        if let gradientLayer = gradientLayer {
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func updateCardImages() {
        let currentImage = movieCardArray[currentIndex]
        let nextImage1 = movieCardArray[(currentIndex + 1) % movieCardArray.count]
        let nextImage2 = movieCardArray[(currentIndex + 2) % movieCardArray.count]
        
        movieCardImageView.image = currentImage
        nextCard1ImageView.image = nextImage1
        nextCard2ImageView.image = nextImage2
        
        // Set initial positions for the next cards
        nextCard1ImageView.center = CGPoint(x: movieCardImageView.center.x, y: movieCardImageView.center.y - 10)
        nextCard2ImageView.center = CGPoint(x: movieCardImageView.center.x, y: movieCardImageView.center.y - 20)
    }
    
    
    private func updateGradientBackground() {
        guard let image = movieCardImageView.image else { return }
        
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
    
    
    func nextImage() {
        currentIndex = (currentIndex + 1) % movieCardArray.count
        movieCardImageView.image = movieCardArray[currentIndex]
        updateGradientBackground()
    }
    
    private func setUpGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        movieCardImageView.addGestureRecognizer(panGestureRecognizer)
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
                    self.nextImage()
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
                    self.nextCard1ImageView.center = self.initialCardCenter
                    self.nextCard2ImageView.center = self.initialCardCenter
                }
            }
        default:
            break
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
