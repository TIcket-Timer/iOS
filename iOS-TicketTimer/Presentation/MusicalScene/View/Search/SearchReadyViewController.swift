//
//  SearchReadyViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct SearchHistorySection {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

extension SearchHistorySection: SectionModelType {
    typealias Item = String
    
    init(original: SearchHistorySection, items: [String]) {
        self = original
        self.items = items
    }
}

protocol SearchReadyViewControllerDelegate: AnyObject {
    func didTapHistoryButton(_: SearchReadyViewController, history: String)
}


class SearchReadyViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: MusicalViewModel
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let recentlyResearchedLabel = UILabel()
    private let tableView = UITableView()
    private var tableViewHeightConstraint: Constraint?
    
    private let recentlyViewedLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    
    weak var delegate: SearchReadyViewControllerDelegate?
    
    init(viewModel: MusicalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUI()
        setAutoLayout()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        self.input.getSearchHistory.onNext([])
        self.input.getMuscialHistory.onNext([])
    }
    
    private func setUI() {
        self.view.backgroundColor = .white

        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        recentlyResearchedLabel.text = "최근 검색어"
        recentlyResearchedLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)

        tableView.register(RecentlyResearchedTableViewCell.self,
                                  forCellReuseIdentifier: RecentlyResearchedTableViewCell.identifier)
        tableView.rowHeight = 30
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false

        let tableViewDataSource = RxTableViewSectionedReloadDataSource<SearchHistorySection> {
            dataSource, tableView, indexPath, item  in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyResearchedTableViewCell.identifier, for: indexPath) as! RecentlyResearchedTableViewCell
            
            cell.cellData.onNext(item)
            
            cell.historyButtonAction = {
                self.delegate?.didTapHistoryButton(self, history: item)
            }
            
            cell.deleteButtonAction = { [weak self] in
                self?.viewModel.deleteSearchHistory(query: item)
                self?.input.getSearchHistory.onNext([])
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        output.bindSearchHistory
            .do { [weak self] sections in
                let newHeight = max(30, sections[0].items.count * 30)
                self?.tableViewHeightConstraint?.update(offset: newHeight)
            }
            .bind(to: tableView.rx.items(dataSource: tableViewDataSource))
            .disposed(by: disposeBag)

        recentlyViewedLabel.text = "최근 본 상품"
        recentlyViewedLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)

        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 120, height: 160)
        flowLayout.minimumLineSpacing = 12

        collectionView.register(RecentlyViewdCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyViewdCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false

        let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<MusicalsSection> {
            dataSource, collectionView, indexPath, item  in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewdCollectionViewCell.identifier, for: indexPath) as! RecentlyViewdCollectionViewCell
            cell.cellData.onNext(item)
            return cell
        }
        
        output.bindMuscialHistory
            .bind(to: collectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Musicals.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.viewModel.showMusicalDetail(self, with: item)
            })
            .disposed(by: disposeBag)
    }
    
    private func setAutoLayout() {
        self.view.addSubview(scrollView)
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
            tableViewHeightConstraint = make.height.equalTo(0).constraint
            //make.height.equalTo(150)
        }
        
        recentlyViewedLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(36 - 8)
            make.leading.equalToSuperview().offset(24)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recentlyViewedLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(160)
            make.bottom.equalToSuperview()
        }
    }
}

