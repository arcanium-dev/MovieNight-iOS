import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureViewComponents()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Clear the navigation stack
        if let navigationController = navigationController {
            navigationController.viewControllers = [self]
        }
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
    
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let authNavController = storyboard.instantiateViewController(withIdentifier: "AuthNavController")
            
            sceneDelegate.window?.rootViewController = authNavController
            sceneDelegate.window?.makeKeyAndVisible()
        } catch let error {
            print("Failed to sign out", error)
        }
    }
    
    func configureViewComponents() {
    }
    
    
}
