//
//  HomeViewController.swift
//  MovieNight-iOS
//
//  Created by Muneeb Bray on 2023/05/13.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureViewComponents()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController (title: nil, message: "Are you sure you want to sign out?",
                                                 preferredStyle: .actionSheet)
        alertController.addAction (UIAlertAction (title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction (UIAlertAction (title: "Cancel", style: .cancel, handler: nil))
        present (alertController, animated: true, completion: nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print("Failed to signout", error)
        }
    }
    
    func configureViewComponents() {
        guard let background = UIImage(named: "purple.png") else {
            return
        }
        view.backgroundColor = UIColor(patternImage: background)
        
        title = "🎥 MovieNight"
        navigationItem.hidesBackButton = true
    }
    
    
}
