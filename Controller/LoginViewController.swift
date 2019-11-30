//
//  ViewController.swift
//  OnTheMap
//
//  Created by fahad on 15/03/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func run(_ sender: Any) {
        API.sessionPost(username: emailTextField.text!, password: passwordTextField.text!) { (errorString) in
            guard errorString == nil else{
                self.showAlert(title: "Something went wrong!", message: errorString!)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
