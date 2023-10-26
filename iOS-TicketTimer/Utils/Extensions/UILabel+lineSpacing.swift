//
//  UILabel+lineSpacing.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/26.
//

import UIKit

extension UILabel {
    func lineSpacing(_ lineSpacing: CGFloat) {
        let attributedString: NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: self.text!)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedString.length)
        )
        self.attributedText = attributedString
    }
}
