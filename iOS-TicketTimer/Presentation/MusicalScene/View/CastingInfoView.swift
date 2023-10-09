//
//  CastingInfoView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/09.
//

import UIKit
import SnapKit

class CastingInfoView: UIView {
    
    private let castingInfoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        castingInfoLabel.text = "캐스팅 정보"
        castingInfoLabel.textColor = .gray
        castingInfoLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    private func setAutoLayout() {
        self.addSubviews([castingInfoLabel])
        
        castingInfoLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(24)
        }
    }
}
