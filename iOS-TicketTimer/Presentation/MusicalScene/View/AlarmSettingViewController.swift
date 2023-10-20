//
//  AlarmSettingViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlarmSettingViewController: UIViewController {
    
    private let notice: MusicalNotice
    private let viewModel: AlarmViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var platformLabel: PlatformLabel = {
        let lb = PlatformLabel(platform: stringToPlatformType(string: notice.siteCategory ?? ""))
        return lb
    }()
    private let titleLabel = UILabel()
    private let titleSpacer = UIView()
    private let reservationLabel = UILabel()
    private let reservationDetail = UILabel()
    private let reservationSpacer = UIView()
    private lazy var titleStackView = UIStackView(arrangedSubviews: [platformLabel, titleLabel, titleSpacer])
    private lazy var reservationStackView = UIStackView(arrangedSubviews: [reservationLabel, reservationDetail, reservationSpacer])
    private let infoContainer = UIView()
    
    private let divider = UIView()
    
    private let fiveMinLabel = UILabel()
    private let tenMinLabel = UILabel()
    private let twentyMinLabel = UILabel()
    private let thirtyMinLabel = UILabel()
    private let fiveMinSwitch = UISwitch()
    private let tenMinSwitch = UISwitch()
    private let twentyMinSwitch = UISwitch()
    private let thirtyMinSwitch = UISwitch()
    private let fiveMinStackView = UIStackView()
    private let tenMinStackView = UIStackView()
    private let twentyMinStackView = UIStackView()
    private let thirtyMinStackView = UIStackView()
    private lazy var MinStackView = UIStackView(arrangedSubviews: [fiveMinStackView, tenMinStackView, twentyMinStackView, thirtyMinStackView])
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
        setAction()
    }
    
    init(notice: MusicalNotice) {
        self.notice = notice
        self.viewModel = AlarmViewModel(notice: notice)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAction() {
        bindSwitch(fiveMinSwitch, to: viewModel.fiveMinSwitchIsOn)
        bindSwitch(tenMinSwitch, to: viewModel.tenMinSwitchIsOn)
        bindSwitch(twentyMinSwitch, to: viewModel.twentyMinSwitchIsOn)
        bindSwitch(thirtyMinSwitch, to: viewModel.thirtyMinSwitchIsOn)
        
        autoAddNextScheduleButton.rx.tap
            .subscribe { [weak self] _ in
                self?.isActiveAutoAddNextSchedule.toggle()
                self?.toggleButtonImage()
            }
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
                self?.viewModel.completeButtonAction()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSwitch(_ minSwitch: UISwitch, to relay: BehaviorRelay<Bool>) {
        relay
            .bind(to: minSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        minSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(minSwitch.rx.isOn)
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white

        platformLabel.platform = stringToPlatformType(string: notice.siteCategory ?? "")
        titleLabel.setup(text: notice.title ?? "", color: .gray100, size: 17, weight: .medium)
        reservationLabel.setup(text: "예매 일정", color: .gray100, size: 15, weight: .medium)
        reservationDetail.setup(text: notice.openDateTime?.toDateAndTime() ?? "", color: .mainColor, size: 15, weight: .medium)
        
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        reservationStackView.axis = .horizontal
        reservationStackView.spacing = 18
        
        divider.backgroundColor = .gray20
 
        fiveMinLabel.setup(text: "5분 전", color: .gray100, size: 15, weight: .regular)
        tenMinLabel.setup(text: "10분 전", color: .gray100, size: 15, weight: .regular)
        twentyMinLabel.setup(text: "20분 전", color: .gray100, size: 15, weight: .regular)
        thirtyMinLabel.setup(text: "30분 전", color: .gray100, size: 15, weight: .regular)
        
        configureStackView(fiveMinStackView, label: fiveMinLabel, Switch: fiveMinSwitch)
        configureStackView(tenMinStackView, label: tenMinLabel, Switch: tenMinSwitch)
        configureStackView(twentyMinStackView, label: twentyMinLabel, Switch: twentyMinSwitch)
        configureStackView(thirtyMinStackView, label: thirtyMinLabel, Switch: thirtyMinSwitch)
        
        MinStackView.axis = .vertical
        MinStackView.spacing = 24
        
        customTimeLabel.setup(text: "사용자 설정", color: .gray100, size: 15, weight: .regular)
        
        autoAddNextScheduleButtonImage.image = UIImage(systemName: "checkmark.circle.fill")
        autoAddNextScheduleButtonImage.tintColor = .gray40
        autoAddNextScheduleButtonImage.contentMode = .scaleAspectFit
        autoAddNextScheduleButtonImage.frame.size = CGSize(width: 20, height: 20)
        autoAddNextScheduleButtonTitle.setup(text: "다음 회차 예매일정 자동 추가", color: .gray100, size: 15, weight: .medium)
        autoAddNextScheduleButtonStackView.axis = .horizontal
        autoAddNextScheduleButtonStackView.spacing = 8
        autoAddNextScheduleButton.backgroundColor = .clear

        addAlarmLabel.setup(text: "알람을 추가하시겠습니까?", color: .gray100, size: 13, weight: .regular)
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.gray80, for: .normal)
        cancelButton.backgroundColor = .gray20
        cancelButton.layer.cornerRadius = 10
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .mainColor
        completeButton.layer.cornerRadius = 10
        
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
        alarmContainer.addSubviews([MinStackView, customTimeLabel, autoAddNextScheduleButtonStackView])
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
        MinStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        customTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(MinStackView.snp.bottom).offset(30)
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
            make.top.equalTo(buttonContainer.snp.top).offset(10)
            make.bottom.equalTo(ButtonStackView.snp.top).offset(-19)
            make.centerX.equalToSuperview()
        }
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
    
    private func toggleButtonImage() {
        UIView.animate(withDuration: 0.3) {
            if self.isActiveAutoAddNextSchedule {
                self.autoAddNextScheduleButtonImage.tintColor = .mainColor
            } else {
                self.autoAddNextScheduleButtonImage.tintColor = .gray40
            }
        }
    }
}

