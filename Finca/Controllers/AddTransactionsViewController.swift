//
//  ViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 3/28/22.
//

import UIKit
import Firebase

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    
    var docRef: DocumentReference!
    
    private var db = Firestore.firestore()
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    let categories = ["", "Gas", "Groceries", "Date night", "Fast Food", "Car Insurance", "Auto", "Parking", "Rent", "Shopping", "Health", "Haircut", "Google Drive", "Apple iCloud", "Danny", "Investments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        hideKeyboardWhenTappedAround()
        amountInput.delegate = self
        companyInput.delegate = self

        categoryTxtField.inputView = categoryPicker
        categoryTxtField.textAlignment = .center
        
        createDatePicker()
        
    }
    
    func inputValidation(textInput: UITextField, inputEnum: textInputs){
        var (validation, message): (Bool, String?) = (false, "")
        
        switch inputEnum {
        case .amount:
            (validation, message) = TransactionValidation.validateField(textInput.text!, .amount)
        case .company:
            (validation, message) = TransactionValidation.validateField(textInput.text!, .company)
        case .category:
            (validation, message) = TransactionValidation.validateField(textInput.text!, .category)
        case .date:
            (validation, message) = TransactionValidation.validateField(textInput.text!, .date)
        case .all:
            (validation, message) = TransactionValidation.validateField(textInput.text!, .all)
        }
        
        if !validation {
            print("hello")
            
            let dialogMessage = UIAlertController(title: "Error", message: message!, preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("Ok button tapped")
            }

            dialogMessage.addAction(ok)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

    func getCurrentUser() -> Substring {
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            return UserHelper.getFilteredEmail(email!)
        } else {
            return "Error getting current user"
        }
    }
    
    func createDatePicker(){
        dateTxtField.textAlignment = .center

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneBtn], animated: true)

        dateTxtField.inputAccessoryView = toolbar
        dateTxtField.inputView = datePicker

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }

    @objc func dateDonePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        dateTxtField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func amountEndEditing(_ sender: UITextField) {
        inputValidation(textInput: amountInput, inputEnum: .amount)
    }
    
    @IBAction func companyEndEditing(_ sender: UITextField) {
        inputValidation(textInput: companyInput, inputEnum: .company)
    }
    
    @IBAction func categoryEndEditing(_ sender: UITextField) {
        inputValidation(textInput: categoryTxtField, inputEnum: .category)
    }
    
    @IBAction func dateEndEditing(_ sender: UITextField) {
        inputValidation(textInput: dateTxtField, inputEnum: .date)
    }
    
    func validateAllFieldsFilled(){
        inputValidation(textInput: amountInput, inputEnum: .all)
        inputValidation(textInput: companyInput, inputEnum: .all)
        inputValidation(textInput: categoryTxtField, inputEnum: .all)
        inputValidation(textInput: dateTxtField, inputEnum: .all)
        
        if self.presentedViewController as? UIAlertController != nil {
            print("presented")
        }
    }
    
    @IBAction func addTransaction(_ sender: Any) {
        validateAllFieldsFilled()
//        let dateHelper = DateFormatChanger(dateStr: dateTxtField.text!)
//
//        let day = dateHelper.getDay()
//        let month = dateHelper.getMonth()
//        let year = dateHelper.getYear()
//
//        guard let amount = Float(amountInput.text!) else { return }
//        guard let company = companyInput.text?.lowercased() else { return }
//        guard let category = categoryTxtField.text?.lowercased() else { return }
//
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//
//        let transactionID = UUID().uuidString
//
//        docRef = Firestore.firestore().document("\(K.UserCollection.collectionName)/\(userID)/\(K.TransactionCollection.collectionName)/\(transactionID)")
//
//        let dataToSave: [String: Any] = ["transactionID": transactionID, "amount": amount, "company": company, "category": category, "day": day, "month": month, "year": year]
//        docRef.setData(dataToSave)
//
//        navigationController?.popViewController(animated: true)
    }

}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTxtField.text = categories[row]
        categoryTxtField.resignFirstResponder()
    }
}

extension AddTransactionViewController: UITextFieldDelegate {
    // Return button tapped
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }

   // Around tapped
   func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTransactionViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }

   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
}
