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
        if let email = emailTextField.text {
            let indexOfAt = email.firstIndex(of: "@")
            let range = email.startIndex..<indexOfAt!
            let filteredUser = email[range]
            print(filteredUser)
        }

        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let errorMessage = error {
                    print("EMAIL: \(email)")
                    print(errorMessage)
                } else {
                    self.performSegue(withIdentifier: K.registerToLanding, sender: self)
                }
            }
            
            guard let indexOfAtSymbol = email.firstIndex(of: "@") else { return  }
            let range = email.startIndex..<indexOfAtSymbol
            let filteredEmail = email[range]
            
            docRef = Firestore.firestore().document("\(K.UserCollection.userCollectionName)/\(filteredEmail)")
            
            let dataToSave: [String: Any] = [K.UserCollection.nameKey: filteredEmail]
            docRef.setData(dataToSave)
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
