//
//  HomeTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/04.
//

import RxSwift
import SnapKit

class HomeTableViewCell: UITableViewCell {
	static let identifier = "homeTableViewCell"
	
	var cellData = PublishSubject<MusicalNotice>()
	private let bag = DisposeBag()
	
	let titleLabel = UILabel()
	let dateLabel = UILabel()
	let timeLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setUI()
		
		cellData
			.observe(on: MainScheduler.instance)
			.withUnretained(self)
			.subscribe(onNext: { (self, data) in
				self.titleLabel.text = data.title?.trimmingCharacters(in: ["\n", "\r", "\t"])
				self.dateLabel.text = data.openDateTime?.toDate()
				self.timeLabel.text = data.openDateTime?.toTime()
			})
			.disposed(by: bag)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = ""
		dateLabel.text = ""
		timeLabel.text = ""
	}

	private func setUI() {
		self.selectionStyle = .none
		
		contentView.addSubviews([titleLabel, dateLabel, timeLabel])
        
		titleLabel.textColor = .gray100
		titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
		titleLabel.lineBreakMode = .byTruncatingTail
		
		dateLabel.textColor = .gray60
		dateLabel.font = .systemFont(ofSize: 15, weight: .medium)
		
		timeLabel.textColor = .mainColor
		timeLabel.font = .systemFont(ofSize: 15, weight: .bold)
		timeLabel.textAlignment = .right
		
		titleLabel.snp.makeConstraints {
			$0.centerY.leading.equalToSuperview()
			$0.trailing.equalTo(dateLabel.snp.leading).offset(-10)
		}
		
		dateLabel.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
			$0.width.equalTo(80)
		}
		
		timeLabel.snp.makeConstraints {
			$0.centerY.trailing.equalToSuperview()
			$0.width.equalTo(50)
		}
	}
}
