//
//  SearchAllResultsView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol SearchAllResultsViewDelegate: AnyObject {
    func didTapCell(_ : SearchAllResultsView)
    func didTapAlarmSetting(_ : SearchAllResultsView, indexPath: IndexPath)
}

class SearchAllResultsView: UIView {
    
    private let disposeBag = DisposeBag()
    var viewModel: MusicalViewModel
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    var type: SearchType? = nil {
        didSet {
            self.updateAutoLayout()
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let filterButton = UIButton()
    private let filterView = FilterView()
    private var selectedPlatforms: Platform? = nil
    
    private let noticeResultLable = UILabel()
    private let noticeTableView = UITableView()
    private var noticeTableViewHeightConstraint: Constraint?
    
    private let musicalResultLable = UILabel()
    private let musicalTableView = UITableView()
    private var musicalTableViewHeightConstraint: Constraint?
    
    weak var delegate: SearchAllResultsViewDelegate?
    
    init(viewModel: MusicalViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUI()
        setAutoLayout()
        setFilter()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        let query = viewModel.query
        if type == .notice {
            input.getNoticSearch.onNext(query)
        } else if type == .musical {
            input.getMusicalSearch.onNext(query)
        }
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        noticeResultLable.text = "오픈공지 검색결과 0건"
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
                self.delegate?.didTapAlarmSetting(self, indexPath: indexPath)
            }
            return cell
        }
        
        output.bindNoticeAllSearch
            .do { [weak self] sections in
                let newHeight = sections[0].items.count * 72
                self?.noticeTableViewHeightConstraint?.update(offset: newHeight)
                self?.noticeResultLable.text = "오픈공지 검색결과 \(sections[0].items.count)건"
            }
            .bind(to: noticeTableView.rx.items(dataSource: noticeDataSoure))
            .disposed(by: disposeBag)
        
        musicalResultLable.text = "공연상세 검색결과 0건"
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
        
        output.bindMusicalAllSearch
            .observe(on: MainScheduler.instance)
            .do { [weak self] sections in
                let newHeight = sections[0].items.count * 200
                self?.musicalTableViewHeightConstraint?.update(offset: newHeight)
                self?.musicalResultLable.text = "공연상세 검색결과 \(sections[0].items.count)건"
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
    }
    
    private func setAutoLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([filterButton, filterView, noticeResultLable, noticeTableView, musicalResultLable, musicalTableView])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func updateAutoLayout() {
        if type == .notice {
            musicalResultLable.removeFromSuperview()
            musicalTableView.removeFromSuperview()
            filterButton.removeFromSuperview()
            filterView.removeFromSuperview()
            contentView.addSubviews([noticeResultLable, noticeTableView])

            noticeResultLable.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(24)
            }
            
            noticeTableView.snp.makeConstraints { make in
                make.top.equalTo(noticeResultLable.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                noticeTableViewHeightConstraint = make.height.equalTo(0).constraint
            }
        } else if type == .musical {
            noticeResultLable.removeFromSuperview()
            noticeTableView.removeFromSuperview()
            contentView.addSubviews([musicalResultLable, musicalTableView, filterButton])
            contentView.addSubview(filterView)
            
            musicalResultLable.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.leading.equalToSuperview().offset(24)
            }

            musicalTableView.snp.makeConstraints { make in
                make.top.equalTo(musicalResultLable.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
                musicalTableViewHeightConstraint = make.height.equalTo(0).constraint
            }
            
            filterButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-24)
            }

            filterView.snp.makeConstraints { make in
                make.top.equalTo(filterButton.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(140)
            }
        }
    }
    
    private func setFilter() {
        // filterButton
        filterButton.setTitle("전체", for: .normal)
        filterButton.setTitleColor(.gray100, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let image = UIImage(systemName: "chevron.up", withConfiguration: imageConfig)
        filterButton.setImage(image, for: .normal)
        filterButton.tintColor = .gray100
        filterButton.semanticContentAttribute = .forceRightToLeft
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        
        filterButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.filterView.isHidden.toggle()
                self.toggleFilterButtonArrow()
            }
            .disposed(by: disposeBag)
        
        // filterView
        //MARK: 사이트별 검색 필터 적용 후에 다시 필터 적용이 안되는 에러
        filterView.isHidden = true
        
        filterView.allButton.rx.tap
            .subscribe { _ in
                print("전체 탭")
                self.hidefilterView()
                self.input.getMusicalSearch.onNext(self.viewModel.query)
            }
            .disposed(by: disposeBag)
        
        filterView.interparkButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                print("인터파크 탭")
                self.hidefilterView()
                self.input.getMusicalSearchWithSite.onNext((.interpark, viewModel.query))
            }
            .disposed(by: disposeBag)
        
        filterView.melonButton.rx.tap
            .subscribe { _ in
                print("멜론 탭")
                self.hidefilterView()
                self.input.getMusicalSearchWithSite.onNext((.melon, self.viewModel.query))
            }
            .disposed(by: disposeBag)
        
        filterView.yes24Button.rx.tap
            .subscribe { _ in
                print("예스24 탭")
                self.hidefilterView()
                self.input.getMusicalSearchWithSite.onNext((.yes24, self.viewModel.query))
            }
            .disposed(by: disposeBag)
    }
    
    private func hidefilterView() {
        self.filterView.isHidden = true
        self.toggleFilterButtonArrow()
    }
    
    private func toggleFilterButtonArrow() {
        if filterView.isHidden {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
            let image = UIImage(systemName: "chevron.up", withConfiguration: imageConfig)
            filterButton.setImage(image, for: .normal)
        } else {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
            let image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
            filterButton.setImage(image, for: .normal)
        }
    }
    
    func resetFilter() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let image = UIImage(systemName: "chevron.up", withConfiguration: imageConfig)
        filterButton.setImage(image, for: .normal)
        
        filterView.isHidden = true
    }
}

//MARK: - FilterView

class FilterView: UIView {

    private let allLabel = UILabel()
    private let allSpacer = UIView()
    private let allArrow = UIImageView()
    let allButton = UIButton()
    
    private let interparkLabel = UILabel()
    private let interparkSpacer = UIView()
    private let interparkArrow = UIImageView()
    let interparkButton = UIButton()

    private let melonLabel = UILabel()
    private let melonSpacer = UIView()
    private let melonArrow = UIImageView()
    let melonButton = UIButton()

    private let yes24Label = UILabel()
    private let yes24Spacer = UIView()
    private let yes24Arrow = UIImageView()
    let yes24Button = UIButton()
    
    private lazy var allStackView = UIStackView(arrangedSubviews: [allLabel, allSpacer, allArrow])
    private lazy var interparkStackView = UIStackView(arrangedSubviews: [interparkLabel, interparkSpacer, interparkArrow])
    private lazy var melonStackView = UIStackView(arrangedSubviews: [melonLabel, melonSpacer, melonArrow])
    private lazy var yes24StackView = UIStackView(arrangedSubviews: [yes24Label, yes24Spacer, yes24Arrow])
    
    var filterAction: ((Platform?) -> Void)?
    
    let divider = UIView()
    
    override init(frame: CGRect) {
        self.filterAction = nil
        super.init(frame: frame)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        allLabel.text = "전체"
        allLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        allArrow.image = UIImage(systemName: "chevron.right")
        allArrow.tintColor = .gray60
        allButton.backgroundColor = .clear
        allButton.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        interparkLabel.text = "인터파크티켓"
        interparkLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        interparkArrow.image = UIImage(systemName: "chevron.right")
        interparkArrow.tintColor = .gray60
        interparkButton.backgroundColor = .clear
        interparkButton.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        melonLabel.text = "멜론티켓"
        melonLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        melonArrow.image = UIImage(systemName: "chevron.right")
        melonArrow.tintColor = .gray60
        melonButton.backgroundColor = .clear
        melonButton.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        yes24Label.text = "yes24"
        yes24Label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        yes24Arrow.image = UIImage(systemName: "chevron.right")
        yes24Arrow.tintColor = .gray60
        yes24Button.backgroundColor = .clear
        yes24Button.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        allStackView.axis = .horizontal
        interparkStackView.axis = .horizontal
        melonStackView.axis = .horizontal
        yes24StackView.axis = .horizontal
        
        divider.backgroundColor = UIColor("#E8E8E8")
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.12
    }
    
    private func setAutoLayout() {
        self.addSubviews([allStackView, interparkStackView, melonStackView, yes24StackView, divider])
        allStackView.addSubview(allButton)
        interparkStackView.addSubview(interparkButton)
        melonStackView.addSubview(melonButton)
        yes24StackView.addSubview(yes24Button)
        
        allStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        allButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        interparkStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        interparkButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        melonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        melonButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        yes24StackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        yes24Button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(1)
        }
    }
    
    @objc func FilterTapped(_ sender: UIButton) {
        if sender == allButton {
            filterAction?(nil)
        } else if sender == interparkButton {
            filterAction?(.interpark)
        } else if sender == melonButton {
            filterAction?(.melon)
        } else if sender == yes24Button {
            filterAction?(.yes24)
        }
    }
}
