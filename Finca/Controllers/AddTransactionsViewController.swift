//
//  ViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 3/28/22.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftUI

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var receipt: UIImageView!
    
    var docRef: DocumentReference!
    
    private var db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private var userId = ""
    private var transactionId = ""
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    let categories = ["", "Gas", "Groceries", "Date night", "Fast Food", "Car Insurance", "Auto", "Parking", "Rent", "Shopping", "Health", "Haircut", "Google Drive", "Apple iCloud", "Danny", "Investments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = Auth.auth().currentUser!.uid
        transactionId = UUID().uuidString
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        hideKeyboardWhenTappedAround()
        amountInput.delegate = self
        companyInput.delegate = self

        categoryTxtField.inputView = categoryPicker
        categoryTxtField.textAlignment = .center
        
        createDatePicker()
        createCameraButton()
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
    
    func validateAllFieldsFilled() -> Bool {
        inputValidation(textInput: amountInput, inputEnum: .amount)
        inputValidation(textInput: companyInput, inputEnum: .company)
        inputValidation(textInput: categoryTxtField, inputEnum: .category)
        inputValidation(textInput: dateTxtField, inputEnum: .date)
        
        if self.presentedViewController as? UIAlertController != nil {
            return false
        } else {
            return true
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
    
    func createCameraButton(){
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        var cameraImage = UIImage(systemName: "camera")
        
        let brandGreen = UIColor(named: "BrandGreen")
        var config = UIImage.SymbolConfiguration(paletteColors: [brandGreen!])
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50.0)))
        
        cameraImage = cameraImage?.withConfiguration(config)
        button.setImage(cameraImage, for: .normal)
        cameraView.addSubview(button)
        button.addTarget(self, action: #selector(self.cameraButtonPressed), for: .touchUpInside)
    }
    
    @objc func cameraButtonPressed(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
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
    
    @IBAction func addTransaction(_ sender: Any) {
        let fieldsFilled = validateAllFieldsFilled()
        if(!fieldsFilled){
            print("Fields were not filled")
            return
        }
        
        let dateHelper = DateFormatChanger(dateStr: dateTxtField.text!)

        let day = dateHelper.getDay()
        let month = dateHelper.getMonth()
        let year = dateHelper.getYear()

        guard let amount = Float(amountInput.text!) else { return }
        guard let company = companyInput.text?.lowercased() else { return }
        guard let category = categoryTxtField.text?.lowercased() else { return }

        docRef = Firestore.firestore().document("\(K.UserCollection.collectionName)/\(userId)/\(K.TransactionCollection.collectionName)/\(transactionId)")

        let dataToSave: [String: Any] = ["transactionID": transactionId, "amount": amount, "company": company, "category": category, "day": day, "month": month, "year": year]
        docRef.setData(dataToSave)

        navigationController?.popViewController(animated: true)
    }

}

extension AddTransactionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        storage.child("images/\(userId)/\(transactionId).png").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("images/\(self.userId)/\(self.transactionId).png").downloadURL { _, error in
                guard error != nil else {
                    print("Issue adding image to storage: \(error)")
                    return
                }
            }
        }

        receipt.image = image
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
