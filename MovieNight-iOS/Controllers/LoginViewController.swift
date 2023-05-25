import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //Create cleaned versions of the data
        
        let formattedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        logUserIn(withEmail: formattedEmail, password: formattedPassword)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "auth_fields_error".localized
        }
        // Validate Fields
        if let errorMessage = Utilities.validateFields(email: emailTextField.text, password: passwordTextField.text, authFlag: "Login") {
               return errorMessage
           }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func logUserIn(withEmail email: String, password: String) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Log in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                // Check for errors
                if error != nil {
                    // There was an error creating the user
                    self.showError("Error signing in user: \(error?.localizedDescription ?? "Invalid password.")")
                }
                else {
                    // Transition to the home screen
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                       let window = sceneDelegate.window {
                        sceneDelegate.showHomeScreen(in: window)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToHome" {
            // Set the tab bar controller's navigation controller as the root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let navigationController = segue.destination as? UINavigationController,
               let tabBarController = navigationController.topViewController as? UITabBarController {
                sceneDelegate.window?.rootViewController = navigationController

                // Set the selected view controller as the home tab
                tabBarController.selectedIndex = 0
            }
        }
    }
}
