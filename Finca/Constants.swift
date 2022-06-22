//
//  Constants.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/8/22.
//

import Foundation

struct K {
    static let registerToLanding = "RegisterToLanding"
    static let loginToLanding = "LoginToLanding"
    static let transactionNibName = "TransactionCell"
    static let showReceiptImage = "ShowReceiptFromEdit"
    static let months = ["Month", "January", "February", "March", "April",
                         "May", "June", "July", "August",
                         "September", "October","November", "December"]
    static let days: [String] = ((1...31).map {String($0)})
    static let years: [String] = ((2020...Calendar.current.component(.year, from: Date())).map {String($0)})
    
    struct UserCollection {
        static let collectionName = "users"
        static let emailKey = "email"
    }
    
    struct TransactionCollection {
        static let collectionName = "transactions"
    }
    
    struct AccountCollection{
        static let collectionName = "accounts"
    }
}
