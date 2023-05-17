//
//  LoginViewController.swift
//  MovieNight-iOS
//
//  Created by Muazzam.Aziz on 2023/05/16.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "MovieNight")
        return imageView
    }()
    
    lazy var emailContainerView: UIView = {
        let view = UIView()
        guard let lock = UIImage(named: "lock") else {
            return view // add return statement here
        }
        return view.textContainerView(view: view, image: lock, textField: emailTextField)
    }()
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        guard let lock = UIImage(named: "user") else {
            return view // add return statement here
        }
        return view.textContainerView(view: view, image: lock, textField: nameTextField)
    }()
    
    lazy var surnameContainerView: UIView = {
        let view = UIView()
        guard let lock = UIImage(named: "user") else {
            return view // add return statement here
        }
        return view.textContainerView(view: view, image: lock, textField: surnameTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        guard let lock = UIImage(named: "lock") else {
            return view // add return statement here
        }
        return view.textContainerView(view: view, image: lock, textField: passwordTextField)
    }()
    
    lazy var errorView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var errorLabel: UILabel = {
        let tf = UILabel()
        tf.textColor = .gray
        tf.numberOfLines = 0
        tf.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return tf
    }()
    
    var emailTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
    }()
    
    var nameTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Name", isSecureTextEntry: false)
    }()
    
    var surnameTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Surname", isSecureTextEntry: false)
    }()
    
    var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry: false)
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton (type: .system)
        button.setTitle ("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.systemFont (ofSize: 18)
        button.setTitleColor(UIColor.init(red: 49/255, green: 86/255, blue: 128/255, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.addTarget (self, action: #selector (handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    let haveAccountButton: UIButton = {
        let button = UIButton (type: .system)
        let attributedTitle = NSMutableAttributedString (string: "Already have an account? ", attributes:
                                                            [NSAttributedString.Key.font: UIFont.systemFont (ofSize: 16), NSAttributedString.Key.foregroundColor:
                                                                UIColor.white])
        attributedTitle.append(NSAttributedString (string: "Login", attributes: [NSAttributedString.Key.font:
                                                                                    UIFont.boldSystemFont (ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget (self, action: #selector (handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleSignUp() {
        guard let name = nameTextField.text else { return }
        guard let surname = surnameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //Create cleaned versions of the data
        
        let formattedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        createUser(withEmail: formattedEmail, password: formattedPassword, name: formattedName, surname: formattedSurname)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func createUser(withEmail email: String, password: String, name: String, surname: String) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message
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
                    db.collection("users").addDocument(data: ["name": name, "surname": surname, "uid": uid]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                            print(("Error saving user data"), error)
                        }
                    }
                    // Transition to the home screen
                    let homeViewController = HomeViewController()
                    let navController = UINavigationController(rootViewController: homeViewController)
                    navController.navigationBar.barStyle = .black

                    UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self.view.window?.rootViewController = navController
                    }, completion: nil)
                }
                
            }
            
            
            
        }
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            surnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
    
    func configureViewComponents() {
        
        errorLabel.alpha = 0
        
        view.backgroundColor = UIColor.init(red: 203/255, green: 223/255, blue: 227/255, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview (logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0,
                             paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview (emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right:
                                    view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview (nameContainerView)
        nameContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right:
                                    view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview (surnameContainerView)
        surnameContainerView.anchor(top: nameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right:
                                    view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview (passwordContainerView)
        passwordContainerView.anchor(top: surnameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right:
                                        view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        view.addSubview (signUpButton)
        signUpButton.anchor (top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right:
                                view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview (errorView)
        errorView.anchor(top: signUpButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right:
                                        view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        errorView.addSubview (errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: errorView.centerYAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: errorView.rightAnchor, constant: -5).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: errorView.leftAnchor, constant: 5).isActive = true
        
        view.addSubview (haveAccountButton)
        haveAccountButton.anchor (top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                                      paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
    }

}
