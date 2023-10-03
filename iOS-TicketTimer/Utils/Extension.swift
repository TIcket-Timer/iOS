//
//  Extensions.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit

// MARK: - 컬러 에셋
extension UIColor {
	class var mainColor: UIColor {
		return UIColor(named: "mainColor")!
	}
	class var gray60: UIColor {
		return UIColor(named: "gray60")!
	}
	class var gray40: UIColor {
		return UIColor(named: "gray40")!
	}
}

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
}
