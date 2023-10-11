//
//  Extensions.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit

extension UIView {
	func addSubviews(_ views: [UIView]) {
		_ = views.map { self.addSubview($0) }
	}
	
	// 뷰를 포함하고 있는 VC
	func viewContainingController() -> UIViewController? {
		var nextResponder: UIResponder? = self
		
		repeat {
			nextResponder = nextResponder?.next
			
			if let viewController = nextResponder as? UIViewController {
				return viewController
			}
			
		} while nextResponder != nil
		
		return nil
	}
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
