//
//  MusicalDetailViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/09.
//

import UIKit

class MusicalDetailViewController: UIViewController {
    
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
    
    private let addAlarmButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        
        bgView.image = UIImage(named: "opera")
        bgView.backgroundColor = UIColor("#040005")
        bgView.contentMode = .scaleAspectFit
        bgView.clipsToBounds = true
        
        imageView.image = UIImage(named: "opera")
        
        viewMusicalDetailButton.setTitle("공연 상세정보 보기", for: .normal)
        viewMusicalDetailButton.setTitleColor(.gray80, for: .normal)
        viewMusicalDetailButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        viewMusicalDetailButton.addTarget(self, action: #selector(viewMusicalDetailButtonTapped), for: .touchUpInside)
        viewMusicalDetailButtonBottom.backgroundColor = .gray80
        
        titleLabel.text = "뮤지컬 <오페라의 유령> - 서울"
        titleLabel.textColor = .gray100
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        venueLabel.text = "공연장"
        venueLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        venueLabel.textColor = .gray100
        
        venueDetail.text = "샤롯데씨어터"
        venueDetail.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        venueDetail.textColor = .gray80
        
        durationLabel.text = "공연기간"
        durationLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        durationLabel.textColor = .gray100
        
        durationDetail.text = "2023.07.21 ~ 2023.11.17"
        durationDetail.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        durationDetail.textColor = .gray80
        
        reservationScheduleLabel.text = "애매일정"
        reservationScheduleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        reservationScheduleLabel.textColor = .gray100
        
        reservationScheduleDetail.text = "2023.07.12 14:00"
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
        
        addAlarmButton.setTitle("예매알람 추가하기", for: .normal)
        addAlarmButton.backgroundColor = .mainColor
        addAlarmButton.layer.cornerRadius = 10
    }
            
    private func setAutoLayout() {
        self.view.addSubviews([bgView, imageView, platfomrLabel, viewMusicalDetailButton, titleLabel, stackViewContainer, divider, addAlarmButton])
        viewMusicalDetailButton.addSubview(viewMusicalDetailButtonBottom)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        platfomrLabel.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(12)
            make.leading.equalTo(imageView.snp.trailing).offset(16)
        }
        
        viewMusicalDetailButton.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(14)
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
        
        addAlarmButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-18)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
    }
    
    @objc func viewMusicalDetailButtonTapped() {
        print(#function)
    }
}
