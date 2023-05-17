//
//  SignUpViewController.swift
//  MovieNight-iOS
//
//  Created by Muazzam.Aziz on 2023/05/17.
//

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
                    self.showError("Error creating user")
                }
                else {
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    guard let uid = result?.user.uid else { return }
                    db.collection("users").addDocument(data: ["firstname": firstname, "lastname": lastname, "uid": uid]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
                    self.performSegue(withIdentifier: "SignUpToHome", sender: self)
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
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
