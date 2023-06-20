import UIKit
import FirebaseAuth
class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleText = "auth_title".localized
        titleLabel.text = titleText
        titleLabel.textColor = .white
        defaultAuthBackground()
        loginButton.defaultButtonStyle(title: "Login")
        signUpButton.defaultButtonStyle(title: "Sign Up")
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
    }
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
}

