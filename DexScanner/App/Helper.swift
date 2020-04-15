//
//  Helper.swift
//  DexScanner
//
//  Created by Janson Hendryli on 11/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

// Computed property to convert only first word to uppercase
extension StringProtocol {
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }
}

// Show spinner when processing the image!
struct Spinner {
    private var spinner: UIView?

    internal mutating func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        self.spinner = spinnerView
    }

    // When processing is done, remove the spinner.
    internal mutating func removeSpinner() {
        self.spinner?.removeFromSuperview()
        self.spinner = nil
    }
}
