import UIKit
import FirebaseAuth
import FirebaseFirestore
import TransitionButton

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var signUpButton: TransitionButton!
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppearance()
        defaultAuthBackground()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
    }
    
    func setUpAppearance() {
        emailTextField.defaultTextFieldStyle(placeholder: "Email")
        passwordTextField.defaultTextFieldStyle(placeholder: "Password")
        firstnameTextField.defaultTextFieldStyle(placeholder: "First Name")
        lastnameTextField.defaultTextFieldStyle(placeholder: "Last Name")
        signUpButton.defaultButtonStyle(title: "Sign Up")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.textAlignment = .left
            emailTextField.attributedPlaceholder = nil
        } else if textField == passwordTextField {
            passwordTextField.textAlignment = .left
            passwordTextField.attributedPlaceholder = nil
        } else if textField == firstnameTextField {
            firstnameTextField.textAlignment = .left
            firstnameTextField.attributedPlaceholder = nil
        } else if textField == lastnameTextField {
            lastnameTextField.textAlignment = .left
            lastnameTextField.attributedPlaceholder = nil
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField && emailTextField.text?.isEmpty ?? true {
            emailTextField.defaultTextFieldStyle(placeholder: "Email")
        } else if textField == passwordTextField && passwordTextField.text?.isEmpty ?? true {
            passwordTextField.defaultTextFieldStyle(placeholder: "Password")
        } else if textField == firstnameTextField && firstnameTextField.text?.isEmpty ?? true {
            firstnameTextField.defaultTextFieldStyle(placeholder: "First Name")
        } else if textField == lastnameTextField && lastnameTextField.text?.isEmpty ?? true {
            lastnameTextField.defaultTextFieldStyle(placeholder: "Last Name")
        }
    }
    
    func setTextFieldStyle(_ textField: UITextField, alignment: NSTextAlignment) {
        textField.textAlignment = alignment
        textField.attributedPlaceholder = nil
        
        switch textField {
        case emailTextField:
            emailTextField.defaultTextFieldStyle(placeholder: "Email")
        case passwordTextField:
            passwordTextField.defaultTextFieldStyle(placeholder: "Password")
        case firstnameTextField:
            firstnameTextField.defaultTextFieldStyle(placeholder: "First Name")
        case lastnameTextField:
            lastnameTextField.defaultTextFieldStyle(placeholder: "Last Name")
        default:
            break
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        signUpButton.startAnimation()
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
        if let error = error {
            signUpButton.stopAnimation(animationStyle: .shake)
            Utilities.showError(message: error, label: errorLabel)
        }
        else {
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
                // Check for errors
                if let error = error {
                    // There was an error creating the user
                    signUpButton.stopAnimation(animationStyle: .shake)
                    Utilities.showError(message: "Error creating user: \(error.localizedDescription)", label: errorLabel)
                }
                else {
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    guard let uid = result?.user.uid else { return }
                    db.collection("users").addDocument(data: ["firstname": firstname, "lastname": lastname, "uid": uid]) { [self] (error) in
                        if let error = error {
                            // Show error message
                            Utilities.showError(message: "Error saving user data: \(error.localizedDescription)", label: errorLabel)
                        }
                    }
                    // Transition to the home screen
                    errorLabel.isHidden = true
                    signUpButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 2) {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                sceneDelegate.showHomeScreen()
                            }
                        }
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
}
