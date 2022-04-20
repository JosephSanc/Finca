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
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let emailRefined = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let passwordRefined = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if let email = emailRefined, let password = passwordRefined {
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

extension LoginViewController: UITextFieldDelegate {
    // Return button tapped
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }

   // Around tapped
   func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }

   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
}
