//
//  RecentlyViewdCollectionViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/07.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

class RecentlyViewdCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecentlyViewdCollectionViewCell"
    
    let cellData = PublishSubject<Musicals>()
    private var disposeBag = DisposeBag()
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
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
        
        cellData
            .bind(onNext: { [weak self] item in
                let url = URL(string: item.posterUrl ?? "")
                self?.imageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
    }
}
