//
//  HomeCollectionViewCell.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/05.
//

import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "homeCollectionViewCell"
    
    let imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setUI() {
        contentView.addSubviews([imageView])
    
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowOpacity = 0.2
        
        imageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(160)
        }
    }
}
