//
//  AlarmListTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources

class AlarmListTableViewCell: UITableViewCell {
    static let identifier = "AlarmListTableViewCell"
    
    let cellData = PublishSubject<Alarm>()
    private var disposeBag = DisposeBag()
    
    private let bgView = UIView()
    private let timeLabel = UILabel()
    private let divider = UIView()
    private let container = UIView()
    private let siteLabel = SiteLabel()
    private let titleLabel = UILabel()
    private let beforMinLabel = UILabel()
    
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
                self.timeLabel.text = data.musicalNotice.openDateTime?.toTime()
                self.siteLabel.site = data.musicalNotice.siteCategory?.toSiteType() ?? .interpark
                self.titleLabel.text = data.musicalNotice.title?.trimmingCharacters(in: ["\n", "\r", "\t"])
                self.beforMinLabel.text = timesToString(data.alarmTimes)
            })
            .disposed(by: disposeBag)
        
        func timesToString(_ times: [Int]) -> String {
            let min = times.map { "\($0)분" }.joined(separator: "/")
            let string = "\(min) 전 알람"
            return string
        }
    }

    private func setUI() {
        contentView.backgroundColor = .gray10
        
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        
        timeLabel.setup(text: "시간", color: .mainColor, size: 17, weight: .bold)
        timeLabel.textAlignment = .center
        divider.backgroundColor = .gray40
        
        siteLabel.setup(text: "사이트", color: .mainColor, size: 15, weight: .bold)
        titleLabel.setup(text: "제목", color: .gray100, size: 17, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.lineSpacing(4)
        titleLabel.lineBreakMode = .byWordWrapping
        beforMinLabel.setup(text: "0분 전 알람", color: .gray80, size: 13, weight: .regular)
    }
    
    private func setAutoLayout() {
        self.addSubview(bgView)
        bgView.addSubviews([timeLabel, divider, container])
        container.addSubviews([siteLabel, titleLabel, beforMinLabel])
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(84)
            make.leading.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalTo(timeLabel.snp.trailing)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.leading.equalTo(divider.snp.trailing).offset(18)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        siteLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(siteLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        beforMinLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.leading.equalToSuperview()
        }
    }
}

