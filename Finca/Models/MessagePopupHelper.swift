//
//  MessagePopupHelper.swift
//  Finca
//
//  Created by Joseph Sanchez on 7/5/22.
//

import Foundation
import UIKit

public struct MessagePopupHelper {
    public static func showMessagePopupOk(_ vc: UIViewController, _ title: String, _ message: String){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default)

        dialogMessage.addAction(okAction)

        vc.present(dialogMessage, animated: true, completion: nil)
    }
    
    public static func showMessagePopupEditCancel(_ vc: UIViewController, _ title: String, _ message: String, completion: @escaping (() -> ())){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //let okAction = UIAlertAction(title: buttonText, style: .default)
        let editAction = UIAlertAction(title: "Edit", style: .default) { okAction in
            completion()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        dialogMessage.addAction(editAction)
        dialogMessage.addAction(cancelAction)

        vc.present(dialogMessage, animated: true, completion: nil)
    }
}
