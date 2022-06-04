//
//  RegisterViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/7/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    var docRef: DocumentReference!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        let emailRefined = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let passwordRefined = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if let email = emailRefined, let password = passwordRefined {
            Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), password: password.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) { authResult, error in
                if let errorMessage = error {
                    print("EMAIL: \(email)")
                    print(errorMessage)
                } else {
                    self.performSegue(withIdentifier: K.registerToLanding, sender: self)
                    
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    guard let email = Auth.auth().currentUser?.email else { return }
        
                    print(userID)
                    print(email)
        
                    self.docRef = Firestore.firestore().document("\(K.UserCollection.collectionName)/\(userID)")
        
                    let dataToSave: [String: Any] = [K.UserCollection.emailKey: email]
                    self.docRef.setData(dataToSave)
                }
            }
        }
    }
}


extension RegisterViewController: UITextFieldDelegate {
    // Return button tapped
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }

   // Around tapped
   func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }

   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
}
