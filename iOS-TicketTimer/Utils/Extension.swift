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
    
    convenience init(_ hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
