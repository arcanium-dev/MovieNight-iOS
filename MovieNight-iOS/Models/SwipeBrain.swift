import Foundation

class SwipeBrain {
    private var movies: [Movie]
    private var currentIndex: Int
    
    init(movies: [Movie]) {
        self.movies = movies
        self.currentIndex = 0
    }
    
    func getCurrentMovie() -> Movie? {
        guard currentIndex < movies.count else {
            return nil
        }
        
        return movies[currentIndex]
    }
    
    func swipeLeft() {
        // Handle logic for swiping left (dislike) on the current movie
        // For example, you can update the data model or perform any necessary operations
        
        // Move to the next movie
        currentIndex += 1
    }
    
    func swipeRight() {
        // Handle logic for swiping right (like) on the current movie
        // For example, you can update the data model or perform any necessary operations
        
        // Move to the next movie
        currentIndex += 1
    }
    
    func swipeUp() {
        // Handle logic for swiping up (watched) on the current movie
        // For example, you can update the data model or perform any necessary operations
        
        // Move to the next movie
        currentIndex += 1
    }
    
    func resetSwipe() {
        // Reset the swipe process to the beginning
        currentIndex = 0
    }
}
