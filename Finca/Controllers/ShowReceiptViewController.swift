//
//  ShowReceiptViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 6/4/22.
//

import Foundation
import UIKit
import SwiftUI

public class ShowReceiptViewController: UIViewController {
    
    @IBOutlet weak var receiptImageView: UIImageView!
    var receiptImage = UIImage()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        receiptImageView.image = receiptImage
        receiptImageView.transform = self.receiptImageView.transform.rotated(by: .pi / 2)
    }
    
}

