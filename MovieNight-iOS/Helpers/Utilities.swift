import Foundation
import UIKit

class Utilities {
    
    static func validateFields(email: String?, password: String?, authFlag: String) -> String? {
        // Check if the password is secure
        let cleanedPassword = password?.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedPassword?.isValidPassword() == false {
            // Password isn't secure enough
            return "auth_password_error".localized
        }
        // Check if email is valid
        let cleanedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedEmail?.isValidEmail() == false {
            // Email isn't valid
            return "auth_email_error".localized
        }
        
        return nil
    }
    
    static func showError(message: String, label: UILabel) {
            label.text = message
            label.alpha = 1
        }
}
