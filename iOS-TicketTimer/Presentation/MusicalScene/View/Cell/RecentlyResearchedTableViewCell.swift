//
//  RecentlyResearchedTableViewCell.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecentlyResearchedTableViewCell: UITableViewCell {
    static let identifier = "RecentlyResearchedTableViewCell"
    
    let cellData = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    
    let historyButton = UIButton()
    let deleteButton = UIButton()
    
    var historyButtonAction: (() -> Void)?
    var deleteButtonAction: (() -> Void)?

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
            .subscribe { [weak self] item in
                if item == "검색 내역이 없습니다." {
                    self?.historyButton.setTitle("검색 내역이 없습니다.", for: .normal)
                    self?.historyButton.isEnabled = false
                    self?.deleteButton.isHidden = true
                } else {
                    self?.historyButton.setTitle(item, for: .normal)
                    self?.historyButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
    }

    private func setUI() {
        historyButton.setTitleColor(.gray60, for: .normal)
        historyButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        historyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.historyButtonAction?()
            })
            .disposed(by: disposeBag)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.tintColor = UIColor.gray60
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.deleteButtonAction?()
            })
            .disposed(by: disposeBag)
    }
    
    private func setAutoLayout() {
        contentView.addSubviews([historyButton, deleteButton])

        historyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1.5)
            make.leading.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.width.equalTo(10)
        }
    }
}
