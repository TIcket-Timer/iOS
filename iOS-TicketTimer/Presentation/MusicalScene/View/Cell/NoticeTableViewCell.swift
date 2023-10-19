//
//  NoticeTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/10.
//

import UIKit
import SnapKit
import RxSwift

class NoticeTableViewCell: UITableViewCell {
    static let identifier = "NoticeTableViewCell"
    
    let cellData = PublishSubject<MusicalNotice>()
    private var disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    
    let alarmSettingButton = UIButton()
    var alarmSettingButtonAction: (() -> Void)?
    
    let container = UIView()
    
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
            .bind(onNext: { [weak self] data in
                guard let self = self else { return }
                self.titleLabel.text = data.title
                self.dateLabel.text = data.openDateTime?.toDate()
                self.timeLabel.text = data.openDateTime?.toTime()
            })
            .disposed(by: disposeBag)

    }

    private func setUI() {
        titleLabel.setup(text: "제목", color: .gray100, size: 15, weight: .medium)
        dateLabel.setup(text: "날짜", color: .gray60, size: 15, weight: .regular)
        timeLabel.setup(text: "시간", color: .mainColor, size: 15, weight: .bold)
        
        alarmSettingButton.setTitle("예매알람 추가", for: .normal)
        alarmSettingButton.setTitleColor(.white, for: .normal)
        alarmSettingButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        alarmSettingButton.backgroundColor = .mainColor
        alarmSettingButton.layer.cornerRadius = 5
        alarmSettingButton.rx.tap
            .subscribe { [weak self] _ in
                self?.alarmSettingButtonAction?()
            }
            .disposed(by: disposeBag)
    }
    
    private func setAutoLayout() {
        contentView.addSubview(container)
        container.addSubviews([titleLabel, dateLabel, timeLabel, alarmSettingButton])
        
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(250)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
        }
        
        alarmSettingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview()
            make.width.equalTo(83)
            make.height.equalTo(28)
        }
    }
}

