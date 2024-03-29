import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultAuthBackground()
        setUpAppearance()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func setUpAppearance() {
        emailTextField.defaultTextFieldStyle(placeholder: "Email")
        passwordTextField.defaultTextFieldStyle(placeholder: "Password")
        loginButton.defaultButtonStyle(title: "Login")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.textAlignment = .left
            emailTextField.attributedPlaceholder = nil
        } else if textField == passwordTextField {
            passwordTextField.textAlignment = .left
            passwordTextField.attributedPlaceholder = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField && emailTextField.text?.isEmpty ?? true {
            emailTextField.defaultTextFieldStyle(placeholder: "Email")
        } else if textField == passwordTextField && passwordTextField.text?.isEmpty ?? true {
            passwordTextField.defaultTextFieldStyle(placeholder: "Password")
        }
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
    
    func logUserIn(withEmail email: String, password: String) {
        // Validate the fields
        let error = validateFields()
        
        if let error = error {
            // There's something wrong with the fields, show error message
            Utilities.showError(message: error, label: errorLabel)
        }
        else {
            // Log in the user
            Auth.auth().signIn(withEmail: email, password: password) { [self] (result, error) in
                // Check for errors
                if let error = error {
                    // There was an error creating the user
                    Utilities.showError(message: "Error signing in user: \(error.localizedDescription)", label: errorLabel)
                }
                else {
                    // Transition to the home screen
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        sceneDelegate.showHomeScreen()
                    }
                }
            }
        }
    }
}
