//
//  ViewController.swift
//  Biometrics
//
//  Created by avinash gautham on 07/05/20.
//  Copyright © 2020 Avinash Gautam. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localAuthenticator = LocalAuthenticator(description: "Login using touchID")
        localAuthenticator.authenticate { (success, error) in
            
            let title: String
            let message: String
            
            if let authError = error {
                title = "Failure"
                message = "Authentication Failed, Error: \(authError.localizedDescription)"
            } else {
                title = "Success"
                message = "Authentication Successful"
            }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

}

