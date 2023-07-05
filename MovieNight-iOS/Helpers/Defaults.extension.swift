import Foundation
import UIKit

extension String {
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var localized: String {
        let value = Bundle.main.localizedString(forKey: self, value: nil, table: "Strings")
        guard !value.isEmpty, value != self else {
            return self
        }
        return value
    }
    
}

extension UIButton {
    func defaultButtonStyle(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Poppins-Medium", size: 16)
        layer.masksToBounds = true
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
}

extension UITextField {
    func defaultTextFieldStyle(placeholder: String) {
        font = UIFont(name: "Poppins-Bold", size: 20)
        textColor = .black
        textAlignment = .center
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#D3D3D3") ?? UIColor.white]
        )
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension UIViewController {
    func defaultAuthBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - (tabBarController?.tabBar.frame.height ?? 0))
        
        if let firstGradient = UIColor(hexString: "#2E1371")?.cgColor,
           let secondGradient = UIColor(hexString: "#48308D")?.cgColor {
            gradientLayer.colors = [firstGradient, secondGradient, firstGradient, UIColor.black.cgColor]
            gradientLayer.locations = [0.0, 0.75, 0.85] // Adjust the location values to make the first color more dominant
        }
        
        if let existingLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingLayer.removeFromSuperlayer()
        }
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func defaultBackground(gradientLayer: CAGradientLayer) {
        
        if let firstGradient = UIColor(hexString: "#2E1371")?.cgColor,
           let secondGradient = UIColor(hexString: "#48308D")?.cgColor {
            gradientLayer.colors = [firstGradient, secondGradient, firstGradient, UIColor.black.cgColor]
            gradientLayer.locations = [0.0, 0.75, 0.85] // Adjust the location values to make the first color more dominant
        }
    }
}


