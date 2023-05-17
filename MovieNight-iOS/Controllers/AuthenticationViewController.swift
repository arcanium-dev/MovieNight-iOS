//
//  ViewController.swift
//  MovieNight-iOS
//
//  Created by Muneeb Bray on 2023/05/13.
//

import UIKit
import FirebaseAuth
class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleText = "🎥 MovieNight"
        titleLabel.text = titleText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            // User is not logged in, stay on the authentication screen
        } else {
            performSegue(withIdentifier: "authToHome", sender: self)
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
    }
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
}

