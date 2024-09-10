//
//  alertFont.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 28/08/2024.
//

import Foundation
import UIKit
extension UIAlertController {
    func setTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: color ?? UIColor.black
        ])
        self.setValue(attributedString, forKey: "attributedTitle")
    }
    
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributedString = NSAttributedString(string: message, attributes: [
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor: color ?? UIColor.black
        ])
        self.setValue(attributedString, forKey: "attributedMessage")
    }
}
