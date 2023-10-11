//
//  UILabel+setup.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/10.
//

import UIKit

extension UILabel {
    func setup(text: String, color: UIColor, size: CGFloat, weight: UIFont.Weight) {
        self.text = text
        self.textColor = color
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
    }
}

