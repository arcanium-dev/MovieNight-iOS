import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        guard let name = firstnameTextField.text else { return }
        guard let surname = lastnameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //Create cleaned versions of the data
        let formattedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        createUser(withEmail: formattedEmail, password: formattedPassword, firstname: formattedName, lastname: formattedSurname)
    }
    
    func createUser(withEmail email: String, password: String, firstname: String, lastname: String) {
        // Validate the fields
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                // Check for errors
                if error != nil {
                    // There was an error creating the user
                    self.showError("Error creating user: \(error?.localizedDescription ?? "error")")
                }
                else {
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    guard let uid = result?.user.uid else { return }
                    db.collection("users").addDocument(data: ["firstname": firstname, "lastname": lastname, "uid": uid]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data: \(error?.localizedDescription ?? "error")")
                        }
                    }
                    // Transition to the home screen
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.isLoggedIn = true
                        sceneDelegate.showHomeScreen(in: sceneDelegate.window!)
                    }
                }
            }
        }
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Validate Fields
        if let errorMessage = Utilities.validateFields(email: emailTextField.text, password: passwordTextField.text, authFlag: "SignUp") {
            return errorMessage
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToHome" {
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
