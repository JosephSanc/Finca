//
//  EditTransactionViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 5/11/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class EditTransactionViewController: UIViewController {
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    var transaction: Transaction = Transaction(transactionID: "", month: 0, day: 0, year: 0, amount: 0.0, company: "", category: "")

    var docRef: DocumentReference!
    var db = Firestore.firestore()
    var storageRef = Storage.storage().reference()
    
    var userID = Auth.auth().currentUser!.uid
    var transactionID = ""
    
    var dialogMessage = UIAlertController()
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    let categories = ["", "Gas", "Groceries", "Date night", "Fast Food", "Car Insurance", "Auto", "Parking", "Rent", "Shopping", "Health", "Haircut", "Google Drive", "Apple iCloud", "Danny", "Investments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amount.text = String(transaction.amount)
        company.text = transaction.company
        category.text = transaction.category
        date.text = "\(DateHelper().getMonthStr(transaction.month)), \(transaction.day), \(transaction.year)"
        
        transactionID = transaction.transactionID
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        hideKeyboardWhenTappedAround()
        amount.delegate = self
        company.delegate = self

        category.inputView = categoryPicker
        category.textAlignment = .center
        
        createDatePicker()
        createCameraButton()
        getReceiptImage()
        addGestureToReceiptImage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.showReceiptImage {
            let showReceiptVC = segue.destination as! ShowReceiptViewController

            if let receiptImage = receiptImageView.image {
                showReceiptVC.receiptImage = receiptImage
            } else {
                print("Error showing bigger image of receipt")
            }
        }
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
    
    func addGestureToReceiptImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        receiptImageView.isUserInteractionEnabled = true
        receiptImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(){
        performSegue(withIdentifier: K.showReceiptImage, sender: self)
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
            dialogMessage = UIAlertController(title: "Error", message: message!, preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("Ok button tapped")
            }

            dialogMessage.addAction(ok)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func validateAllFieldsFilled() -> Bool {
        inputValidation(textInput: amount, inputEnum: .amount)
        inputValidation(textInput: company, inputEnum: .company)
        inputValidation(textInput: category, inputEnum: .category)
        inputValidation(textInput: date, inputEnum: .date)
        
        if self.presentedViewController as? UIAlertController != nil {
            return false
        } else {
            return true
        }
    }
    
    @objc func cameraButtonPressed(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
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
    
    func getReceiptImage(){
        let imageRef = storageRef.child("images/\(userID)/\(transactionID).png")
        
        imageRef.getData(maxSize: 1 * 4200 * 4200, completion: { data, error in
            if let err = error {
                print("Error getting receipt: \(err)")
            } else {
                let image = UIImage(data: data!)
                self.receiptImageView.transform = self.receiptImageView.transform.rotated(by: .pi / 2)
                self.receiptImageView.image = image
            }
        })
    }
    
    func updateTransactionData(){
        let fieldsFilled = validateAllFieldsFilled()
        if(!fieldsFilled){
            print("Fields were not filled")
            return
        }

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
        
    }
    
    func updateReceiptImage(){
        let imageData = receiptImageView.image?.pngData()
        
        if let imgData = imageData {
            storageRef.child("images/\(userID)/\(transactionID).png").putData(imgData, metadata: nil) { _, error in
                guard error == nil else {
                    print("Failed to upload")
                    return
                }
            }
        } else {
            print("We have a problemo")
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
        updateTransactionData()
        updateReceiptImage()
        navigationController?.popViewController(animated: true)
    }
}

extension EditTransactionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        receiptImageView.image = image
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
