//
//  UIViewControllerExtention.swift
//  On The Map
//
//  Created by Naif Alrashed on 3/3/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeAndShowAlertView(message: String, subMessage: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message, message: subMessage, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
