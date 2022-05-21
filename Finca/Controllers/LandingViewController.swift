//
//  LandingViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/7/22.
//

import UIKit
import Firebase

class LandingViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    @IBAction func TestingTransaction(_ sender: UIButton) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
  
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("month", isEqualTo: 4).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let month = document.data()["month"] as! Int
                    let day = document.data()["day"] as! Int
                    let year = document.data()["year"] as! Int
                    let amount = document.data()["amount"] as! Float
                    let company = document.data()["company"] as! String
                    let category = document.data()["category"] as! String
                    let transaction = Transaction(transactionID: document.documentID, month: month, day: day, year: year, amount: amount, company: company, category: category)
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
    }
}
