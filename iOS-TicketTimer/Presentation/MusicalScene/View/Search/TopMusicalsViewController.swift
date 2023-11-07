//
//  MusicalSearchResultViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class TopMusicalsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: MusicalViewModel
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
        
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let popularMusicalLabel = UILabel()
    
    private var selectedSite: Site = .interpark
    private let SiteButtonContainer = UIView()
    private let interparkButton = UIButton()
    private let melonButton = UIButton()
    private let yes24Button = UIButton()
    
    private let popularTableView = UITableView()
    private let popularTableViewRowHeight: CGFloat = 200
        
    init(viewModel: MusicalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        selectSiteButton(interparkButton)
        
        input.getTopMusicals.onNext(.interpark)
    }

    private func setUI() {
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        popularMusicalLabel.text = "인기공연 TOP 10"
        popularMusicalLabel.textColor = .gray100
        popularMusicalLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        SiteButtonContainer.backgroundColor = .gray20
        SiteButtonContainer.layer.cornerRadius = 16
        
        interparkButton.setTitle("인터파크", for: .normal)
        interparkButton.setTitleColor(.gray80, for: .normal)
        interparkButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        interparkButton.addTarget(self, action: #selector(selectSiteButton(_:)), for: .touchUpInside)
        
        melonButton.setTitle("멜론", for: .normal)
        melonButton.setTitleColor(.gray80, for: .normal)
        melonButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        melonButton.addTarget(self, action: #selector(selectSiteButton(_:)), for: .touchUpInside)
        
        yes24Button.setTitle("yes24", for: .normal)
        yes24Button.setTitleColor(.gray80, for: .normal)
        yes24Button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        yes24Button.addTarget(self, action: #selector(selectSiteButton(_:)), for: .touchUpInside)
        
        interparkButton.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.input.getTopMusicals.onNext(.interpark)
            })
            .disposed(by: disposeBag)
        
        melonButton.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.input.getTopMusicals.onNext(.melon)
            })
            .disposed(by: disposeBag)
        
        yes24Button.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.input.getTopMusicals.onNext(.yes24)
            })
            .disposed(by: disposeBag)
        
        popularTableView.register(MusicalTableViewCell.self,
                                  forCellReuseIdentifier: MusicalTableViewCell.identifier)
        popularTableView.rowHeight = popularTableViewRowHeight
        
        let dataSource = RxTableViewSectionedReloadDataSource<MusicalsSection> {
            dataSource, tableView, indexPath, item  in
            let cell = tableView.dequeueReusableCell(withIdentifier: MusicalTableViewCell.identifier, for: indexPath) as! MusicalTableViewCell
            cell.cellData.onNext(item)
            return cell
        }
        
        output.bindPopularMusicals
            .bind(to: popularTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(
            popularTableView.rx.itemSelected,
            popularTableView.rx.modelSelected(Musicals.self)
        )
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let self = self else { return }
            self.popularTableView.deselectRow(at: indexPath, animated: true)
            
            self.viewModel.showMusicalDetail(self, with: item)
        })
        .disposed(by: disposeBag)
    }

    private func setAutoLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([popularMusicalLabel, SiteButtonContainer, popularTableView])
        SiteButtonContainer.addSubviews([interparkButton, melonButton, yes24Button])

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        popularMusicalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }

        SiteButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(popularMusicalLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(76)
            make.width.equalTo(240)
            make.height.equalTo(32)
        }
        interparkButton.snp.makeConstraints { make in
            make.width.equalTo(240 / 3)
            make.height.equalToSuperview()
            make.top.leading.equalToSuperview()
        }
        melonButton.snp.makeConstraints { make in
            make.width.equalTo(240 / 3)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalTo(interparkButton.snp.trailing)
        }
        yes24Button.snp.makeConstraints { make in
            make.width.equalTo(240 / 3)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalTo(melonButton.snp.trailing)
        }

        popularTableView.snp.makeConstraints { make in
            make.top.equalTo(SiteButtonContainer.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(popularTableViewRowHeight * 10)
        }
    }
    
    @objc private func selectSiteButton(_ sender: UIButton) {
        if sender == interparkButton {
            selectedSite = .interpark
        } else if sender == melonButton {
            selectedSite = .melon
        } else if sender == yes24Button {
            selectedSite = .yes24
        }
        
        UIView.animate(withDuration: 0.3) {
            self.interparkButton.setTitleColor(.gray60, for: .normal)
            self.interparkButton.layer.borderColor = UIColor.clear.cgColor
            self.interparkButton.backgroundColor = .clear
            self.melonButton.setTitleColor(.gray60, for: .normal)
            self.melonButton.layer.borderColor = UIColor.clear.cgColor
            self.melonButton.backgroundColor = .clear
            self.yes24Button.setTitleColor(.gray60, for: .normal)
            self.yes24Button.layer.borderColor = UIColor.clear.cgColor
            self.yes24Button.backgroundColor = .clear
            
            sender.setTitleColor(UIColor.mainColor, for: .normal)
            sender.layer.borderColor = UIColor.mainColor.cgColor
            sender.layer.borderWidth = 1.0
            sender.layer.cornerRadius = 16
            sender.backgroundColor = .white
        }
    }
}
