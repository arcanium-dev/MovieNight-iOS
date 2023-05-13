# Movie Night App

Movie Night App is a mobile application that allows users to discover, browse, and track movies. Users can create an account, select their favorite genres, and receive personalized movie recommendations based on their preferences. The app provides a swiping interface to indicate user preferences for movies. Users can add movies to their watchlist and manage their account settings.

## Features

- Login/Auth with Firebase: Users can create an account and authenticate using their email and password.
- Onboarding: Users can select their favorite genres during the onboarding process to receive personalized movie recommendations.
- For You Home Page: Displays movie cards with a swipe system to indicate user preference (swipe left for "no," right for "yes," and up for "watched").
- Browse Movies: Allows users to browse movies from any genre.
- Watchlist: Users can add movies to their watchlist for future viewing.
- Account Settings: Users can manage their account settings, such as updating their profile information or changing their password.

## Installation

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on a simulator or physical device running iOS 16.0 or later.
4. Ensure you have an active internet connection to access Firebase services.

## Technologies Used

- Swift: Programming language used for iOS app development.
- Xcode: Integrated development environment (IDE) for iOS app development.
- Firebase: Backend-as-a-Service (BaaS) platform used for authentication and data storage.

## Folder Structure

The project follows the MVC (Model-View-Controller) architecture pattern. Here's an overview of the folder structure:

- Controllers: Contains the view controllers responsible for managing different screens and their logic.
- Models: Includes the data models used within the app.
- Views: Contains separate storyboard files for each view.
- Helpers: Contains helper classes and utility files for handling Firebase authentication, genre selection, and movie swipe functionality.
- Extensions: Includes extension files providing additional functionality to existing Swift classes or UIKit components.
- Supporting Files: Contains essential app-related files such as the AppDelegate and Info.plist.
- Tests: Includes unit tests for the view controllers.
- Resources/Images: Holds image assets used in the app.

