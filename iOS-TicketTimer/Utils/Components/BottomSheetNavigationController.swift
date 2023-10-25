//
//  BottomSheetNavigationController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/23.
//

import UIKit

class BottomSheetNavigationController: UINavigationController {
    
    private let heigth: CGFloat
    
    init(rootViewController: UIViewController, heigth: CGFloat) {
        self.heigth = heigth
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateViewConstraints() {
        self.view.frame.size.height = heigth
        self.view.frame.origin.y = UIScreen.main.bounds.height - heigth
        self.view.layer.cornerRadius = 30
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        super.updateViewConstraints()
    }
}


