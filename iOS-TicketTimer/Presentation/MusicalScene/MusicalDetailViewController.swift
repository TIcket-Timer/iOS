//
//  MusicalDetailViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import SafariServices

class MusicalDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let musical: Musicals
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let musicalImageView = UIImageView()
    private lazy var musicalInfoView = MusicalInfo(musical: musical)
    private lazy var musicalInfoStackView = UIStackView(arrangedSubviews: [musicalImageView, musicalInfoView])
    
    private let divider = UIView()
    
    private let actorInfoLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var actorInfoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
    private let collectionViewItemSize = CGSize(width: 90, height: 138)
    private var collectionViewHeightConstraint: Constraint?
    
    private let showSafariButton = UIButton()
    
    init(musical: Musicals) {
        self.musical = musical
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        updateCollectionViewHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        navigationItem.title = "공연 상세 정보"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        
        scrollView.showsVerticalScrollIndicator = false
        
        guard let url = musical.posterUrl else { return }
        musicalImageView.kf.setImage(with: URL(string: url))
        musicalImageView.contentMode = .scaleAspectFit
        musicalImageView.layer.masksToBounds = false
        musicalImageView.layer.shadowColor = UIColor.black.cgColor
        musicalImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        musicalImageView.layer.shadowOpacity = 0.2
        
        musicalImageView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.width.equalTo(120)
        }
        
        musicalInfoStackView.axis = .horizontal
        musicalInfoStackView.spacing = 18
        musicalInfoStackView.alignment = .top
        musicalInfoStackView.distribution = .fill
        
        divider.backgroundColor = .gray20
        
        actorInfoLabel.setup(text: "배우 정보", color: .gray100, size: 17, weight: .bold)
        
        actorInfoCollectionView.delegate = self
        actorInfoCollectionView.dataSource = self
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = collectionViewItemSize
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 36
        actorInfoCollectionView.register(ActorInfoCollectionViewCell.self, forCellWithReuseIdentifier: ActorInfoCollectionViewCell.identifier)
        actorInfoCollectionView.showsVerticalScrollIndicator = false
        actorInfoCollectionView.isScrollEnabled = false
        
        showSafariButton.setTitle("공연정보 사이트로 가기", for: .normal)
        showSafariButton.setTitleColor(.white, for: .normal)
        showSafariButton.backgroundColor = .mainColor
        showSafariButton.layer.cornerRadius = 10
        showSafariButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let urlString = self?.musical.siteLink,
                      let url = URL(string: urlString),
                      UIApplication.shared.canOpenURL(url)
                else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
    }
            
    private func setAutoLayout() {
        self.view.addSubviews([scrollView, showSafariButton])
        scrollView.addSubview(contentView)
        contentView.addSubviews([musicalInfoStackView, divider, actorInfoLabel, actorInfoCollectionView])
        
        showSafariButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-18)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(showSafariButton.snp.top).offset(-5)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview()
        }
                
        musicalInfoStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(musicalInfoStackView.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        actorInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        actorInfoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(actorInfoLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
            collectionViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    func updateCollectionViewHeight() {
        let newHeight = (Int(collectionViewItemSize.height) * (musical.actors.count / 3)) + (20 * ((musical.actors.count / 3) - 1))
        collectionViewHeightConstraint?.update(offset: newHeight)
        self.view.layoutIfNeeded()
    }
}

extension MusicalDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musical.actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorInfoCollectionViewCell.identifier, for: indexPath) as! ActorInfoCollectionViewCell

        guard let actor = musical.actors[indexPath.row] else { return UICollectionViewCell() }
        let url = URL(string: actor.profileUrl!)
        cell.actorImageView.kf.setImage(with: url)
        cell.roleNameLabel.text = actor.roleName
        cell.actorNameLabel.text = actor.actorName
        
        return cell
    }
}

class MusicalInfo: UIView {
    
    let musical: Musicals
    
    private lazy var platformLabel: PlatformLabel = {
        let lb = PlatformLabel(platform: stringToPlatformType(string: musical.siteCategory ?? ""))
        return lb
    }()
    
    private let titleLabel = UILabel()
    
    private let venueLabel = UILabel()
    private let venueDetail = UILabel()
    lazy private var venueStackView = UIStackView(arrangedSubviews: [venueLabel, venueDetail])
    
    private let durationLabel = UILabel()
    private let durationDetail = UILabel()
    lazy private var durationStackView = UIStackView(arrangedSubviews: [durationLabel, durationDetail])
    
    private let ageLabel = UILabel()
    private let ageDetail = UILabel()
    lazy private var ageStackView = UIStackView(arrangedSubviews: [ageLabel, ageDetail])
    
    private let priceLabel = UILabel()
    private let priceDetail = UILabel()
    lazy private var priceStackView = UIStackView(arrangedSubviews: [priceLabel, priceDetail])
    
    lazy private var stackViewContainer = UIStackView(arrangedSubviews: [venueStackView, durationStackView, ageStackView, priceStackView])
    
    init(musical: Musicals) {
        self.musical =  musical
        super.init(frame: .zero)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        titleLabel.setup(text: musical.title ?? "", color: .gray100, size: 17, weight: .bold)
        titleLabel.numberOfLines = 0

        venueLabel.setup(text: "공연장", color: .gray100, size: 13, weight: .medium)
        venueDetail.setup(text: musical.place ?? "", color: .gray80, size: 13, weight: .regular)
        venueDetail.numberOfLines = 0
        
        venueStackView.axis = .horizontal
        venueStackView.spacing = 26
        venueStackView.alignment = .top

        durationLabel.setup(text: "공연기간", color: .gray100, size: 13, weight: .medium)
        guard
            let startDate = musical.startDate,
            let endDate = musical.endDate
        else { return }
        durationDetail.setup(text: "\(changeDateFormat(startDate))~\(changeDateFormat(endDate))", color: .gray80, size: 13, weight: .regular)
        
        durationStackView.axis = .horizontal
        durationStackView.spacing = 14
        
        ageLabel.setup(text: "관람연령", color: .gray100, size: 13, weight: .medium)
        ageDetail.setup(text: musical.age ?? "", color: .gray80, size: 13, weight: .regular)
        
        ageStackView.axis = .horizontal
        ageStackView.spacing = 14
        
        priceLabel.setup(text: "가격", color: .gray100, size: 13, weight: .medium)
        let price = musical.price.compactMap { $0 }.joined(separator: "\n")
        priceDetail.setup(text: price, color: .gray80, size: 13, weight: .regular)
        priceDetail.numberOfLines = 0
        priceDetail.lineSpacing(4)
        
        priceStackView.axis = .horizontal
        priceStackView.spacing = 37
        priceStackView.alignment = .top

        stackViewContainer.axis = .vertical
        stackViewContainer.spacing = 8
        stackViewContainer.alignment = .leading
    }
    
    private func setAutoLayout() {
        self.addSubviews([platformLabel, titleLabel, stackViewContainer])
        
        platformLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(platformLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        stackViewContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func changeDateFormat(_ date: String) -> String {
        let inputDateFormat = "yyyy-MM-dd"
        let outputDateFormat = "yyyy.MM.dd"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormat
        
        guard let date = dateFormatter.date(from: date) else { return "" }
        
        dateFormatter.dateFormat = outputDateFormat
        return dateFormatter.string(from: date)
    }
    
    private func stringToPlatformType(string: String) -> Platform {
        if string == "INTERPARK" {
            return .interpark
        } else if string == "MELON" {
            return .melon
        } else {
            return .yes24
        }
    }
}
