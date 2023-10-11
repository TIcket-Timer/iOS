//
//  NoticeTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/10.
//

import UIKit
import SnapKit

class NoticeTableViewCell: UITableViewCell {
    static let identifier = "NoticeTableViewCell"
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    
    let alarmSettingButton = UIButton()
    var alarmSettingButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUI() {
        titleLabel.setup(text: "제목", color: .gray100, size: 17, weight: .medium)
        dateLabel.setup(text: "날짜", color: .gray80, size: 13, weight: .regular)
        timeLabel.setup(text: "시간", color: .mainColor, size: 15, weight: .bold)
        
        alarmSettingButton.setTitle("알람 설정", for: .normal)
        alarmSettingButton.setTitleColor(.white, for: .normal)
        alarmSettingButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        alarmSettingButton.backgroundColor = .mainColor
        alarmSettingButton.layer.cornerRadius = 10
        alarmSettingButton.addTarget(self, action: #selector(alarmSettingButtonTapped), for: .touchUpInside)
    }
    
    private func setAutoLayout() {
        contentView.addSubviews([titleLabel, dateLabel, timeLabel, alarmSettingButton])

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        
        alarmSettingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(65)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(alarmSettingButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(timeLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func alarmSettingButtonTapped() {
        alarmSettingButtonAction?()
    }
}

