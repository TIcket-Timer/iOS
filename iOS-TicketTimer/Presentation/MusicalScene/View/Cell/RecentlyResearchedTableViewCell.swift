//
//  RecentlyResearchedTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/07.
//

import UIKit
import SnapKit

class RecentlyResearchedTableViewCell: UITableViewCell {
    static let identifier = "RecentlyResearchedTableViewCell"
    
    let recentlySearchedTextLabel = UILabel()
    let deleteButton = UIButton()
    
    var deleteButtonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setAutoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUI() {
        recentlySearchedTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        recentlySearchedTextLabel.textColor = UIColor.gray60
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.tintColor = UIColor.gray60
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setAutoLayout() {
        contentView.addSubviews([recentlySearchedTextLabel, deleteButton])

        recentlySearchedTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1.5)
            make.leading.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.width.equalTo(10)
        }
    }
    
    @objc func deleteButtonTapped() {
        deleteButtonAction?()
    }
}
