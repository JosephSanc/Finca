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
  
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("company", isEqualTo: "walmart").getDocuments { querySnapshot, err in
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
                    let transaction = Transaction(month: month, day: day, year: year, amount: amount, company: company, category: category)
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
//        let docRef = db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).document("AB5CFAD7-AB8B-4C49-A0C5-611989255CC3")
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
//                print("Cached document data: \(dataDescription)")
//            } else {
//                print("Document does not exist in cache")
//            }
//        }
        
        print("hello")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
