//
//  UIViewController+Extension.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import UIKit

extension UIViewController {
    func popupAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)

            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)

            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)
        }
    }
}
