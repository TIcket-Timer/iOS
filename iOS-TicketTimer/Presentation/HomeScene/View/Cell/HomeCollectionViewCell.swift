//
//  HomeCollectionViewCell.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/05.
//

import RxSwift
import SnapKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "homeCollectionViewCell"
    
    var cellData = PublishSubject<Musicals>()
    private let bag = DisposeBag()
    
    let imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
        
        cellData
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, data) in
                let url = URL(string: data.posterUrl ?? "")
                self.imageView.kf.setImage(with: url)
            })
            .disposed(by: bag)
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
