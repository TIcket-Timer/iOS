//
//  MemoListTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources

class MemoListTableViewCell: UITableViewCell {
    static let identifier = "MemoListTableViewCell"
    
    let cellData = PublishSubject<Memo>()
    private var disposeBag = DisposeBag()
    
    private let bgView = UIView()
    private let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setAutoLayout()
        bindData()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func bindData() {
        cellData
            .bind(onNext: { [weak self] memo in
                guard let self = self else { return }
                self.contentLabel.text = memo.content
            })
            .disposed(by: disposeBag)
    }

    private func setUI() {
        contentView.backgroundColor = .gray10
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        
        contentLabel.setup(text: "내용", color: .gray100, size: 15, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.lineSpacing(4)
        contentLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setAutoLayout() {
        self.addSubview(bgView)
        bgView.addSubviews([contentLabel])
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
        }
    }
}


