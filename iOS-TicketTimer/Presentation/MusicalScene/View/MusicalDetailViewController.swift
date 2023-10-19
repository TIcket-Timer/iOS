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
    
    private let bgView = UIImageView()
    
    private let imageView = UIImageView()
    private let platfomrLabel = PlatformLabel(platform: .interpark)
    private let viewMusicalDetailButton = UIButton()
    private let viewMusicalDetailButtonBottom = UIView()

    private let titleLabel = UILabel()
    private let venueLabel = UILabel()
    private let venueDetail = UILabel()
    private let durationLabel = UILabel()
    private let durationDetail = UILabel()
    private let reservationScheduleLabel = UILabel()
    private let reservationScheduleDetail = UILabel()
    
    lazy private var venueStackView = UIStackView(arrangedSubviews: [venueLabel, venueDetail])
    lazy private var durationStackView = UIStackView(arrangedSubviews: [durationLabel, durationDetail])
    lazy private var reservationScheduleStackView = UIStackView(arrangedSubviews: [reservationScheduleLabel, reservationScheduleDetail])
    lazy private var stackViewContainer = UIStackView(arrangedSubviews: [venueStackView, durationStackView, reservationScheduleStackView])
    
    private let divider = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }
    
    init(musical: Musicals) {
        self.musical = musical
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        
        guard let url = musical.posterUrl else { return }
        bgView.kf.setImage(with: URL(string: url))
        bgView.backgroundColor = UIColor("#040005")
        bgView.contentMode = .scaleAspectFit
        bgView.clipsToBounds = true
        
        imageView.kf.setImage(with: URL(string: url))
        
        viewMusicalDetailButton.setTitle("공연 상세정보 보기", for: .normal)
        viewMusicalDetailButton.setTitleColor(.gray80, for: .normal)
        viewMusicalDetailButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        viewMusicalDetailButtonBottom.backgroundColor = .gray80
        
        viewMusicalDetailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let urlString = self?.musical.siteLink,
                      let url = URL(string: urlString),
                      UIApplication.shared.canOpenURL(url)
                else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
        
        titleLabel.text = musical.title
        titleLabel.textColor = .gray100
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        venueLabel.text = "공연장"
        venueLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        venueLabel.textColor = .gray100
        
        venueDetail.text = musical.place
        venueDetail.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        venueDetail.textColor = .gray80
        
        durationLabel.text = "공연기간"
        durationLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        durationLabel.textColor = .gray100
        
        guard let startDate = musical.startDate else { return }
        guard let endDate = musical.endDate else { return }
        durationDetail.text = "\(startDate) ~ \(endDate)"
        durationDetail.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        durationDetail.textColor = .gray80
        
        reservationScheduleLabel.text = "애매일정"
        reservationScheduleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        reservationScheduleLabel.textColor = .gray100
        
        reservationScheduleDetail.text = "삭제 예정"
        reservationScheduleDetail.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        reservationScheduleDetail.textColor = .gray80
        
        venueStackView.axis = .horizontal
        venueStackView.spacing = 36
        venueStackView.alignment = .center
        
        durationStackView.axis = .horizontal
        durationStackView.spacing = 24
        durationStackView.alignment = .center
        
        reservationScheduleStackView.axis = .horizontal
        reservationScheduleStackView.spacing = 24
        reservationScheduleStackView.alignment = .center
        
        stackViewContainer.axis = .vertical
        stackViewContainer.spacing = 8
        stackViewContainer.alignment = .leading
        
        divider.backgroundColor = .gray20
    }
            
    private func setAutoLayout() {
        self.view.addSubviews([bgView, imageView, platfomrLabel, viewMusicalDetailButton, titleLabel, stackViewContainer, divider])
        viewMusicalDetailButton.addSubview(viewMusicalDetailButtonBottom)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(160)
            make.width.equalTo(120)
        }
        
        platfomrLabel.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(12)
            make.leading.equalTo(imageView.snp.trailing).offset(16)
        }
        
        viewMusicalDetailButton.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(13)
        }
        
        viewMusicalDetailButtonBottom.snp.makeConstraints { make in
            make.bottom.left.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(24)
        }
                
        stackViewContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(stackViewContainer.snp.bottom).offset(27)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}
