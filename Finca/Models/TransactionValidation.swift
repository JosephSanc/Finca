//
//  TransactionValidation.swift
//  Finca
//
//  Created by Joseph Sanchez on 5/13/22.
//

import Foundation

struct TransactionValidation {

    static func validateField(_ text: String, _ inputEnum: textInputs) -> (Bool, String?){
        let textIsEmpty = text.isEmpty
        let floatParseResult = Float(text) ?? -1.0
        
        if textIsEmpty || floatParseResult == -1.0 {
            switch inputEnum {
            case .amount:
                return (false, "Please enter a number amount")
            case .company:
                return (false, "Please enter a company name")
            case .category:
                return (false, "Please select a category")
            case .date:
                return (false, "Please select a date")
            }
        } else {
            return (true, nil)
        }
    }
}

enum textInputs {
    case amount
    case company
    case category
    case date
}
