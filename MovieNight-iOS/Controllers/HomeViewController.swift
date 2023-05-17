//
//  HomeViewController.swift
//  MovieNight-iOS
//
//  Created by Muneeb Bray on 2023/05/13.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "hello"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        authUserAndConfigureView()
        // Do any additional setup after loading the view.
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        } catch let error {
            print("Failed to signout", error)
        }
    }
    func authUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        } else {
            configureViewComponents()
        }
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController (title: nil, message: "Are you sure you want to sign out?",
                                                 preferredStyle: .actionSheet)
        alertController.addAction (UIAlertAction (title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction (UIAlertAction (title: "Cancel", style: .cancel, handler: nil))
        present (alertController, animated: true, completion: nil)
    }
    
    func configureViewComponents () {
        view.backgroundColor = UIColor.init(red: 203/255, green: 223/255, blue: 227/255, alpha: 1)  
        navigationItem.title = "Firebase Login"
        guard let back = UIImage(named: "back") else {
            return
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: back, style: .plain, target: self, action:
                                                            #selector (handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        view.addSubview (welcomeLabel)
        welcomeLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
