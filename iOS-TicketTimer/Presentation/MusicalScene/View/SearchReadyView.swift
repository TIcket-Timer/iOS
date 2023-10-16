//
//  SearchReadyView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol SearchReadyViewDelegate: AnyObject {
    func didTapCell(_: SearchReadyView, indexPath: IndexPath)
}

class SearchReadyView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let recentlyResearchedLabel = UILabel()
    private let tableView = UITableView()
    private var tableViewHeightConstraint: Constraint?
    private var tableViewNumberOfRow: Int {
        return max(1, min(searchList.count, 5))
    }
    
    private let recentlyViewedLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    
    weak var delegate: SearchReadyViewDelegate?
    
    var searchList: [String] = ["오페라10", "오페라9", "오페라8", "오페라7", "오페라6", "오페라5", "오페라4", "오페라3", "오페라2", "오페라1"] {
        didSet {
            tableView.reloadData()
            updateTableViewHeight()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        recentlyResearchedLabel.text = "최근 검색어"
        recentlyResearchedLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentlyResearchedTableViewCell.self,
                                  forCellReuseIdentifier: RecentlyResearchedTableViewCell.identifier)
        tableView.rowHeight = 30
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        recentlyViewedLabel.text = "최근 본 상품"
        recentlyViewedLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)

        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 120, height: 160)
        flowLayout.minimumLineSpacing = 12
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecentlyViewdCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyViewdCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setAutoLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([recentlyResearchedLabel, tableView, recentlyViewedLabel, collectionView])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        recentlyResearchedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentlyResearchedLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(30 * tableViewNumberOfRow)
            tableViewHeightConstraint = make.height.equalTo(30 * tableViewNumberOfRow).constraint
        }

        recentlyViewedLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(36 - 8)
            make.leading.equalToSuperview().offset(24)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recentlyViewedLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
            make.height.equalTo(160)
        }
    }
    
    private func updateTableViewHeight() {
        tableViewHeightConstraint?.update(offset: 30 * tableViewNumberOfRow)
        layoutIfNeeded()
    }
}

// MARK: - recentlyResearchedTableView

extension SearchReadyView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewNumberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyResearchedTableViewCell.identifier, for: indexPath) as! RecentlyResearchedTableViewCell

        cell.selectionStyle = .none
        
        if searchList.isEmpty {
            cell.recentlySearchedTextLabel.text = "검색 내역이 없습니다."
            cell.deleteButton.isHidden = true
        } else {
            cell.recentlySearchedTextLabel.text = searchList[indexPath.row]
            cell.deleteButton.isHidden = false
            cell.deleteButtonAction = {
                self.searchList.remove(at: indexPath.row)
            }
        }
        
        return cell
    }
}

// MARK: - recentlyViewdCollectionView

extension SearchReadyView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewdCollectionViewCell.identifier, for: indexPath) as! RecentlyViewdCollectionViewCell
        
        cell.imageView.image = UIImage(named: "opera")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCell(self, indexPath: indexPath)
    }
}
