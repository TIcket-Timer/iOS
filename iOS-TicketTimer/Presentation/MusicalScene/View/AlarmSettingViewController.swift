//
//  AlarmSettingViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/10.
//

import UIKit
import SnapKit

class AlarmSettingViewController: UIViewController {
    
    var platform: Platform
    private let platformLabel = PlatformLabel(platform: .interpark)
    private let titleLabel = UILabel()
    private let titleSpacer = UIView()
    private let reservationLabel = UILabel()
    private let reservationDetail = UILabel()
    private let reservationSpacer = UIView()
    private lazy var titleStackView = UIStackView(arrangedSubviews: [platformLabel, titleLabel, titleSpacer])
    private lazy var reservationStackView = UIStackView(arrangedSubviews: [reservationLabel, reservationDetail, reservationSpacer])
    private let infoContainer = UIView()
    
    private let divider = UIView()
    
    private let fiveMinuteLabel = UILabel()
    private let tenMinuteLabel = UILabel()
    private let twentyMinuteLabel = UILabel()
    private let thirtyMinuteLabel = UILabel()
    private let fiveMinuteSwitch = UISwitch()
    private let tenMinuteSwitch = UISwitch()
    private let twentyMinuteSwitch = UISwitch()
    private let thirtyMinuteSwitch = UISwitch()
    private let fiveMinuteStackView = UIStackView()
    private let tenMinuteStackView = UIStackView()
    private let twentyMinuteStackView = UIStackView()
    private let thirtyMinuteStackView = UIStackView()
    private lazy var minuteStackView = UIStackView(arrangedSubviews: [fiveMinuteStackView, tenMinuteStackView, twentyMinuteStackView, thirtyMinuteStackView])
    private let customTimeLabel = UILabel()
    private let autoAddNextScheduleButtonImage = UIImageView()
    private let autoAddNextScheduleButtonTitle = UILabel()
    private lazy var autoAddNextScheduleButtonStackView = UIStackView(arrangedSubviews: [autoAddNextScheduleButtonImage, autoAddNextScheduleButtonTitle])
    private let autoAddNextScheduleButton = UIButton()
    private let alarmContainer = UIView()
    
    private let addAlarmLabel = UILabel()
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    private lazy var ButtonStackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
    private let buttonContainer = UIView()
    
    private var isActiveAutoAddNextSchedule = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(platform: Platform) {
        self.platform = platform
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white

        platformLabel.platform = self.platform
        titleLabel.setup(text: "뮤지컬 <오페라의 유령>", color: .gray100, size: 17, weight: .medium)
        reservationLabel.setup(text: "예매 일정", color: .gray100, size: 15, weight: .medium)
        reservationDetail.setup(text: "2023.07.12 14:00", color: .mainColor, size: 15, weight: .medium)
        
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        reservationStackView.axis = .horizontal
        reservationStackView.spacing = 18
        
        divider.backgroundColor = .gray20
 
        fiveMinuteLabel.setup(text: "5분 전", color: .gray100, size: 15, weight: .regular)
        tenMinuteLabel.setup(text: "10분 전", color: .gray100, size: 15, weight: .regular)
        twentyMinuteLabel.setup(text: "20분 전", color: .gray100, size: 15, weight: .regular)
        thirtyMinuteLabel.setup(text: "30분 전", color: .gray100, size: 15, weight: .regular)
        
        fiveMinuteSwitch.tag = 1
        tenMinuteSwitch.tag = 2
        twentyMinuteSwitch.tag = 3
        thirtyMinuteSwitch.tag = 4
        fiveMinuteSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        tenMinuteSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        twentyMinuteSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        thirtyMinuteSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        
        configureStackView(fiveMinuteStackView, label: fiveMinuteLabel, Switch: fiveMinuteSwitch)
        configureStackView(tenMinuteStackView, label: tenMinuteLabel, Switch: tenMinuteSwitch)
        configureStackView(twentyMinuteStackView, label: twentyMinuteLabel, Switch: twentyMinuteSwitch)
        configureStackView(thirtyMinuteStackView, label: thirtyMinuteLabel, Switch: thirtyMinuteSwitch)
        
        minuteStackView.axis = .vertical
        minuteStackView.spacing = 24
        
        customTimeLabel.setup(text: "사용자 설정", color: .gray100, size: 15, weight: .regular)
        
        autoAddNextScheduleButtonImage.image = UIImage(systemName: "checkmark.circle.fill")
        autoAddNextScheduleButtonImage.tintColor = .gray40
        autoAddNextScheduleButtonImage.contentMode = .scaleAspectFit
        autoAddNextScheduleButtonImage.frame.size = CGSize(width: 20, height: 20)
        autoAddNextScheduleButtonTitle.setup(text: "다음 회차 예매일정 자동 추가", color: .gray100, size: 15, weight: .medium)
        autoAddNextScheduleButtonStackView.axis = .horizontal
        autoAddNextScheduleButtonStackView.spacing = 8
        autoAddNextScheduleButton.backgroundColor = .clear
        autoAddNextScheduleButton.addTarget(self, action: #selector(autoAddNextScheduleButtonTapped), for: .touchUpInside)

        addAlarmLabel.setup(text: "알람을 추가하시겠습니까?", color: .gray100, size: 13, weight: .regular)
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.gray80, for: .normal)
        cancelButton.backgroundColor = .gray20
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .mainColor
        completeButton.layer.cornerRadius = 10
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        ButtonStackView.axis = .horizontal
        ButtonStackView.distribution = .fillEqually
        ButtonStackView.spacing = 24
    }
    
    private func configureStackView(_ stackView: UIStackView, label: UILabel, Switch: UISwitch) {
        stackView.axis = .horizontal

        stackView.addArrangedSubview(label)
        let spacer = UIView()
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(Switch)
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([infoContainer, divider, alarmContainer, buttonContainer])
        infoContainer.addSubviews([titleStackView, reservationStackView])
        alarmContainer.addSubviews([minuteStackView, customTimeLabel, autoAddNextScheduleButtonStackView])
        autoAddNextScheduleButtonStackView.addSubview(autoAddNextScheduleButton)
        buttonContainer.addSubviews([addAlarmLabel, ButtonStackView])
        
        // infoContainer
        infoContainer.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
        }
        reservationStackView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // divider
        divider.snp.makeConstraints { make in
            make.top.equalTo(infoContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        // alarmContainer
        alarmContainer.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        minuteStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        customTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(minuteStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        autoAddNextScheduleButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(customTimeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        autoAddNextScheduleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // buttonContainer
        buttonContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
        }
        ButtonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        addAlarmLabel.snp.makeConstraints { make in
            make.bottom.equalTo(ButtonStackView.snp.top).offset(-19)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func switchTapped(_ sender: UISwitch) {
        switch sender.tag {
        case 1:
            if sender.isOn {
                
            } else {
                
            }
        case 2:
            if sender.isOn {
                
            } else {
                
            }
        case 3:
            if sender.isOn {
                
            } else {
                
            }
        case 4:
            if sender.isOn {
                
            } else {
                
            }
        default:
            break
        }
    }
    
    @objc func autoAddNextScheduleButtonTapped() {
        isActiveAutoAddNextSchedule.toggle()
        toggleButtonImage()
    }
    
    private func toggleButtonImage() {
        UIView.animate(withDuration: 0.3) {
            if self.isActiveAutoAddNextSchedule {
                self.autoAddNextScheduleButtonImage.tintColor = .mainColor
            } else {
                self.autoAddNextScheduleButtonImage.tintColor = .gray40
            }
        }
    }
    
    @objc func cancleButtonTapped() {
        print(#function)
    }
    
    @objc func completeButtonTapped() {
        print(#function)
    }
}

