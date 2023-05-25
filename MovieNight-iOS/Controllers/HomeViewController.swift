import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
