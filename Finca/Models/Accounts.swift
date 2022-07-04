//
//  Accounts.swift
//  Finca
//
//  Created by Joseph Sanchez on 6/30/22.
//

import Foundation

struct Accounts {
    public var accountsID: String?
    public var month: Int?
    public var year: Int?
    public var emergencyFund: Float?
    public var downPaymentFund: Float?
    public var macStudioFund: Float?
    public var wellsFargoCheckings: Float?
    public var allyCheckings: Float?
    public var rothIRA: Float?
    public var individualBrokerage: Float?
    public var crypto: Float?
    public var fourOneK: Float?
    public var studentLoans: Float?
    
    init(_ accountsID: String?, _ month: Int?, _ year: Int?, _ emergencyFund: Float?, _ downPaymentFund: Float?, _ macStudioFund: Float?, _ wellsFargoCheckings: Float?, _ allyCheckings: Float?, _ rothIRA: Float?, _ individualBrokerage: Float?, _ crypto: Float?, _ fourOneK: Float?, _ studentLoans: Float?){
        
        self.accountsID = accountsID
        self.month = month
        self.year = year
        self.emergencyFund = emergencyFund
        self.downPaymentFund = downPaymentFund
        self.macStudioFund = macStudioFund
        self.wellsFargoCheckings = wellsFargoCheckings
        self.allyCheckings = allyCheckings
        self.rothIRA = rothIRA
        self.individualBrokerage = individualBrokerage
        self.crypto = crypto
        self.fourOneK = fourOneK
        self.studentLoans = studentLoans
    }
}
