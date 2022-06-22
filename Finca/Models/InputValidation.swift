//
//  TransactionValidation.swift
//  Finca
//
//  Created by Joseph Sanchez on 5/13/22.
//

import Foundation

struct InputValidation {

    static func validateField(_ text: String, _ inputEnum: textInputs) -> (Bool, String?){
        let textIsEmpty = text.isEmpty
        let floatParseResult = Float(text) ?? -1.0
        
        switch inputEnum {
        case .amount:
            let result = floatParseResult == -1.0 ? (false, "Please enter a number amount") : (true, nil)
            return result
        case .company:
            let result = textIsEmpty ? (false, "Please enter a company name") : (true, nil)
            return result
        case .category:
            let result = textIsEmpty ? (false, "Please select a catagory") : (true, nil)
            return result
        case .date:
            if(textIsEmpty || text == "Month" || text == "Day" || text == "Year"){
                return (false, "Please select a date")
            }
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
