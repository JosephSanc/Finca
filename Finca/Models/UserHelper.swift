//
//  UserHelper.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/15/22.
//

import Foundation

struct UserHelper{
    
    public static func getFilteredEmail(_ email: String) -> Substring{
        guard let indexOfAtSymbol = email.firstIndex(of: "@") else { return "Error Filtering Email"}
        let range = email.startIndex..<indexOfAtSymbol
        return email[range]
    }
    
}
