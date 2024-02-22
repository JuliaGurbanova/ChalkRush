//
//  UIView+Extension.swift
//  ChalkRush
//
//  Created by Julia Gurbanova on 19.02.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
