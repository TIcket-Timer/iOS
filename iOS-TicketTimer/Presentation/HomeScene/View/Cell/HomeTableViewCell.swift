//
//  HomeTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/04.
//

import SnapKit

class HomeTableViewCell: UITableViewCell {
	static let identifier = "homeTableViewCell"
	
	let label = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
        label.text = ""
	}

	private func setUI() {
		self.selectionStyle = .none
		
		contentView.addSubviews([label])
        
        label.textColor = .gray100
        label.font = .systemFont(ofSize: 15)
		
		label.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
}
