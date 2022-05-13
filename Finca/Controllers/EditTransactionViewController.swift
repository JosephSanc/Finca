//
//  EditTransactionViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 5/11/22.
//

import Foundation
import UIKit
import Firebase

class EditTransactionViewController: UIViewController {
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var date: UITextField!
    
    var transaction: Transaction = Transaction(transactionID: "", month: 0, day: 0, year: 0, amount: 0.0, company: "", category: "")

    var docRef: DocumentReference!
    private var db = Firestore.firestore()
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    let categories = ["", "Gas", "Groceries", "Date night", "Fast Food", "Car Insurance", "Auto", "Parking", "Rent", "Shopping", "Health", "Haircut", "Google Drive", "Apple iCloud", "Danny", "Investments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amount.text = String(transaction.amount)
        company.text = transaction.company
        category.text = transaction.category
        date.text = "\(DateHelper().getMonthStr(transaction.month)), \(transaction.day), \(transaction.year)"
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        hideKeyboardWhenTappedAround()
        amount.delegate = self
        company.delegate = self

        category.inputView = categoryPicker
        category.textAlignment = .center
        
        createDatePicker()
    }
    
    func createDatePicker(){
        date.textAlignment = .center

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneBtn], animated: true)

        date.inputAccessoryView = toolbar
        date.inputView = datePicker

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }

    @objc func dateDonePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
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
        }
        
        if !validation {
            let dialogMessage = UIAlertController(title: "Error", message: message!, preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("Ok button tapped")
            }

            dialogMessage.addAction(ok)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    @IBAction func amountEndEditing(_ sender: UITextField) {
        inputValidation(textInput: amount, inputEnum: .amount)
    }
    
    @IBAction func companyEndEditing(_ sender: UITextField) {
        inputValidation(textInput: company, inputEnum: .company)
    }
    
    @IBAction func categoryEndEditing(_ sender: UITextField) {
        inputValidation(textInput: category, inputEnum: .category)
    }
    
    @IBAction func dateEndEditing(_ sender: UITextField) {
        inputValidation(textInput: date, inputEnum: .date)
    }
    
    @IBAction func submitBtn(_ sender: UIButton){
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let transactionID = transaction.transactionID

        docRef = Firestore.firestore().document("\(K.UserCollection.collectionName)/\(userID)/\(K.TransactionCollection.collectionName)/\(transactionID)")
        
        let dateFormatChange = DateFormatChanger(dateStr: date.text!)
        transaction.amount = Float(amount.text!)!
        transaction.company = company.text!
        transaction.category = category.text!
        transaction.day = dateFormatChange.getDay()
        transaction.month = dateFormatChange.getMonth()
        transaction.year = dateFormatChange.getYear()
        
        let dataToSave: [String: Any] = ["transactionID": transaction.transactionID, "amount": transaction.amount, "company": transaction.company, "category": transaction.category, "day": transaction.day, "month": transaction.month, "year": transaction.year]
        docRef.setData(dataToSave)
        
        navigationController?.popViewController(animated: true)
    }
}

extension EditTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        category.text = categories[row]
        category.resignFirstResponder()
    }
}

extension EditTransactionViewController: UITextFieldDelegate {
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
