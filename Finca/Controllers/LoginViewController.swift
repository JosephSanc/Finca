//
//  LoginViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/7/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginBtn(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let errorMessage = error {
                    print(errorMessage)
                } else {
                    self.performSegue(withIdentifier: K.loginToLanding, sender: self)
                }
            }
        }
    }
    
}
