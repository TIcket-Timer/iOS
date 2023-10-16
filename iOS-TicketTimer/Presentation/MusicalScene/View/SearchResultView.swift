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
    func didTapCell(_ : SearchResultView, indexPath: IndexPath)
    func didTapAlarmSetting(_ : SearchResultView, indexPath: IndexPath)
    func didTapShowAllResults(resultType: ShowAllResultsType)
}

class SearchResultView: UIView {
    
    private let disposeBag = DisposeBag()
    var viewModel: MusicalViewModel
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let emptyLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let numberOfNoticeResult = 0
    private let noticeResultLable = UILabel()
    private let noticeResultShowAllButton = ShowAllResultsButton()
    private let noticeTableView = UITableView()
    private let noticeTableViewRowHeight: CGFloat = 72
    
    private let numberOfMusicalResult = 0
    private let musicalResultLable = UILabel()
    private let musicalResultShowAllButton = ShowAllResultsButton()
    private let musicalTableView = UITableView()
    private let musicalTableViewRowHeight: CGFloat = 200
    
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
    
    private func setUI() {
        self.backgroundColor = .white
        
        emptyLabel.text = "검색 결과가 없습니다."
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        noticeResultLable.text = "검색결과 \(numberOfMusicalResult)건"
        noticeResultLable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        noticeTableView.register(NoticeTableViewCell.self,
                                  forCellReuseIdentifier: NoticeTableViewCell.identifier)
        noticeTableView.rowHeight = noticeTableViewRowHeight
        noticeTableView.isScrollEnabled = false
        
        musicalResultLable.text = "검색결과 \(numberOfMusicalResult)건"
        musicalResultLable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        musicalTableView.delegate = self
        musicalTableView.dataSource = self
        musicalTableView.register(MusicalTableViewCell.self,
                                  forCellReuseIdentifier: MusicalTableViewCell.identifier)
        musicalTableView.rowHeight = musicalTableViewRowHeight
        musicalTableView.isScrollEnabled = false
        
        noticeResultShowAllButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapShowAllResults(resultType: .notice)
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
            make.height.equalTo(noticeTableViewRowHeight * 2)
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
            make.height.equalTo(musicalTableViewRowHeight * 2)
        }
    }
}

//MARK: - TableView

extension SearchResultView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case noticeTableView:
            return 4
        case musicalTableView:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tableView {
        case noticeTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as! NoticeTableViewCell
            
            cell.titleLabel.text = "뮤지컬 <오페라의 유령 유령 유령 유령 유령 유령 유령 유령>"
            cell.dateLabel.text = "2023.7.12"
            cell.timeLabel.text = "14:00"
            cell.alarmSettingButtonAction = {
                self.delegate?.didTapAlarmSetting(self, indexPath: indexPath)
            }
            
            return cell
        case musicalTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: MusicalTableViewCell.identifier, for: indexPath) as! MusicalTableViewCell
            
            cell.musicalImageView.image = UIImage(named: "opera")
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCell(self, indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
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

