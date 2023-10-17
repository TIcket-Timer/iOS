//
//  SearchInactiveView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol SearchInactiveViewDelegate: AnyObject {
    func didTapCell(_: SearchInactiveView)
}

class SearchInactiveView: UIView {
    
    private let disposeBag = DisposeBag()
    var viewModel: MusicalViewModel
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
        
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let popularMusicalLabel = UILabel()
    
    private var selectedPlatform: Platform = .interpark
    private let platformButtonContainer = UIView()
    private let interparkButton = UIButton()
    private let melonButton = UIButton()
    private let yes24Button = UIButton()
    
    private let popularTableView = UITableView()
    private let popularTableViewRowHeight: CGFloat = 200
    
    weak var delegate: SearchInactiveViewDelegate?
    
    init(viewModel: MusicalViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUI()
        setAutoLayout()
        selectPlatformButton(interparkButton)
        
        input.getPopularMusicals.onNext(.interpark)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        popularMusicalLabel.text = "인기공연 TOP 10"
        popularMusicalLabel.textColor = .gray100
        popularMusicalLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        platformButtonContainer.backgroundColor = .gray20
        platformButtonContainer.layer.cornerRadius = 16
        
        interparkButton.setTitle("인터파크", for: .normal)
        interparkButton.setTitleColor(.gray80, for: .normal)
        interparkButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        interparkButton.addTarget(self, action: #selector(selectPlatformButton(_:)), for: .touchUpInside)
        
        melonButton.setTitle("멜론", for: .normal)
        melonButton.setTitleColor(.gray80, for: .normal)
        melonButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        melonButton.addTarget(self, action: #selector(selectPlatformButton(_:)), for: .touchUpInside)
        
        yes24Button.setTitle("yes24", for: .normal)
        yes24Button.setTitleColor(.gray80, for: .normal)
        yes24Button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        yes24Button.addTarget(self, action: #selector(selectPlatformButton(_:)), for: .touchUpInside)
        
        interparkButton.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.input.getPopularMusicals.onNext(.interpark)
            })
            .disposed(by: disposeBag)
        
        melonButton.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.input.getPopularMusicals.onNext(.melon)
            })
            .disposed(by: disposeBag)
        
        yes24Button.rx.tap
            .subscribe(onNext:  { [weak self] in
                self?.input.getPopularMusicals.onNext(.yes24)
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
        
//        popularTableView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                self?.delegate?.didTapCell(self!, indexPath: indexPath)
//                self?.popularTableView.deselectRow(at: indexPath, animated: true)
//            })
//            .disposed(by: disposeBag)
//
//        popularTableView.rx.modelSelected(Musicals.self)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] musical in
//                self?.viewModel.selectedMusical = musical
//            })
//            .disposed(by: disposeBag)
        
        Observable.zip(
            popularTableView.rx.itemSelected,
            popularTableView.rx.modelSelected(Musicals.self)
        )
        .subscribe(onNext: { [weak self] indexPath, item in
            self?.viewModel.selectedMusical = item
            self?.delegate?.didTapCell(self!)
            self?.popularTableView.deselectRow(at: indexPath, animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func setAutoLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([popularMusicalLabel, platformButtonContainer, popularTableView])
        platformButtonContainer.addSubviews([interparkButton, melonButton, yes24Button])

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

        platformButtonContainer.snp.makeConstraints { make in
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
            make.top.equalTo(platformButtonContainer.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(popularTableViewRowHeight * 10)
        }
    }
    
    @objc private func selectPlatformButton(_ sender: UIButton) {
        if sender == interparkButton {
            selectedPlatform = .interpark
        } else if sender == melonButton {
            selectedPlatform = .melon
        } else if sender == yes24Button {
            selectedPlatform = .yes24
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
