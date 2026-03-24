//
//  UIView + Extension.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import Foundation
import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
