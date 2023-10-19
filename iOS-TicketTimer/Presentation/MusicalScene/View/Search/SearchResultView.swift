//
//  SearchResultView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol SearchResultViewDelegate: AnyObject {
    func didTapCell(_ : SearchResultView)
    func didTapAlarmSetting(_ : SearchResultView)
    func didTapShowAllResults(resultType: SearchType)
}

class SearchResultView: UIView {
    
    private let disposeBag = DisposeBag()
    var viewModel: MusicalViewModel
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let emptyLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let noticeResultLable = UILabel()
    private let noticeResultShowAllButton = ShowAllResultsButton()
    private let noticeTableView = UITableView()
    private var noticeTableViewHeightConstraint: Constraint?

    private let musicalResultLable = UILabel()
    private let musicalResultShowAllButton = ShowAllResultsButton()
    private let musicalTableView = UITableView()
    private var musicalTableViewHeightConstraint: Constraint?

    private var selectedPlatforms: [Platform] = Platform.allCases
    
    weak var delegate: SearchResultViewDelegate?
    
    init(viewModel: MusicalViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let query = viewModel.query
        input.getMusicalSearch.onNext(query)
        input.getNoticSearch.onNext(query)
    }

    private func setUI() {
        self.backgroundColor = .white
        
        emptyLabel.text = "검색 결과가 없습니다."
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        noticeResultLable.text = "오픈공지 검색결과"
        noticeResultLable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        noticeTableView.register(NoticeTableViewCell.self,
                                  forCellReuseIdentifier: NoticeTableViewCell.identifier)
        noticeTableView.rowHeight = 72
        noticeTableView.isScrollEnabled = false
        
        let noticeDataSoure = RxTableViewSectionedReloadDataSource<MusicalNoticeSection> {
            dataSource, tableView, indexPath, item  in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as! NoticeTableViewCell
            cell.cellData.onNext(item)
            cell.alarmSettingButtonAction = {
                self.delegate?.didTapAlarmSetting(self)
            }
            return cell
        }
        
        output.bindNoticeLimitedSearch
            .do { [weak self] sections in
                let newHeight = sections[0].items.count * 72
                self?.noticeTableViewHeightConstraint?.update(offset: newHeight)
                self?.noticeResultLable.text = sections[0].items.isEmpty
                ? "오픈공지 검색결과가 없습니다."
                : "오픈공지 검색결과"
                self?.noticeResultShowAllButton.isHidden = sections[0].items.count < 2
            }
            .bind(to: noticeTableView.rx.items(dataSource: noticeDataSoure))
            .disposed(by: disposeBag)
        
        noticeResultShowAllButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapShowAllResults(resultType: .notice)
            })
            .disposed(by: disposeBag)
        
        musicalResultLable.text = "공연상세 검색결과"
        musicalResultLable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        musicalTableView.register(MusicalTableViewCell.self,
                                  forCellReuseIdentifier: MusicalTableViewCell.identifier)
        musicalTableView.rowHeight = 200
        musicalTableView.isScrollEnabled = false
        
        let musicalDataSource = RxTableViewSectionedReloadDataSource<MusicalsSection> {
            dataSource, tableView, indexPath, item  in
            let cell = tableView.dequeueReusableCell(withIdentifier: MusicalTableViewCell.identifier, for: indexPath) as! MusicalTableViewCell
            cell.cellData.onNext(item)
            return cell
        }
        
        output.bindMusicalLimitedSearch
            .do { [weak self] sections in
                let newHeight = sections[0].items.count * 200
                self?.musicalTableViewHeightConstraint?.update(offset: newHeight)
                self?.musicalResultLable.text = sections[0].items.isEmpty
                ? "공연상세 검색결과가 없습니다."
                : "공연상세 검색결과"
                self?.musicalResultShowAllButton.isHidden = sections[0].items.count < 2
            }
            .bind(to: musicalTableView.rx.items(dataSource: musicalDataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(
            musicalTableView.rx.itemSelected,
            musicalTableView.rx.modelSelected(Musicals.self)
        )
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let self = self else { return }
            self.viewModel.selectedMusical = item
            self.delegate?.didTapCell(self)
            self.musicalTableView.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: disposeBag)
        
        musicalResultShowAllButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapShowAllResults(resultType: .musical)
            })
            .disposed(by: disposeBag)
    }
    
    private func setAutoLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([noticeResultLable, noticeResultShowAllButton, noticeTableView, musicalResultLable, musicalResultShowAllButton, musicalTableView])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        noticeResultLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        noticeResultShowAllButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        noticeTableView.snp.makeConstraints { make in
            make.top.equalTo(noticeResultLable.snp.bottom)
            make.leading.trailing.equalToSuperview()
            noticeTableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        
        musicalResultLable.snp.makeConstraints { make in
            make.top.equalTo(noticeTableView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(24)
        }
        
        musicalResultShowAllButton.snp.makeConstraints { make in
            make.top.equalTo(noticeTableView.snp.bottom).offset(25)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        musicalTableView.snp.makeConstraints { make in
            make.top.equalTo(musicalResultLable.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            musicalTableViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }
}

//MARK: - ShowAllResults

class ShowAllResultsButton: UIView {
    
    private let label = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        label.setup(text: "전체보기", color: .gray100, size: 13, weight: .regular)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        imageView.image = image
        imageView.tintColor = .gray100
        
        self.addSubviews([label, imageView])
        
        label.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
    }
}

