//
//  ActorInfoCollectionViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/24.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

class ActorInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "ActorInfoCollectionViewCell"
    
    private var disposeBag = DisposeBag()
    
    let actorImageView = UIImageView()
    let roleNameLabel = UILabel()
    let actorNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubviews([actorImageView, roleNameLabel, actorNameLabel])
    
        actorImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
        }
        actorImageView.layer.cornerRadius = 45
        actorImageView.clipsToBounds = true
        
        roleNameLabel.setup(text: "역할명", color: .gray100, size: 15, weight: .bold)
        actorNameLabel.setup(text: "배우명", color: .gray80, size: 15, weight: .regular)
        
        actorImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.top.leading.trailing.equalToSuperview()
        }
        
        roleNameLabel.snp.makeConstraints { make in
            make.top.equalTo(actorImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        actorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(roleNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}

