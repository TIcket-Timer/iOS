//
//  PlatformLabel.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/10.
//

import UIKit

class PlatformLabel: PaddingLabel {
    
    var platform: Platform {
        didSet {
            setup()
        }
    }
    
    init(platform: Platform) {
        self.platform = platform
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.text = platform.ticket
            self.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            self.textColor = platform.color
            self.padding = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 9
            self.layer.borderColor = platform.color.cgColor
            self.clipsToBounds = true
    }
}
