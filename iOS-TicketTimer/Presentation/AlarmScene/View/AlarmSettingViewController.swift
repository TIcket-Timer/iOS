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
import RxGesture

class AlarmSettingViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: AlarmViewModel
    private lazy var input = viewModel.input
    private lazy var output = viewModel.output
        
    private lazy var siteLabel: SiteLabel = {
        let lb = SiteLabel(site: stringToSiteType(string: viewModel.notice?.siteCategory ?? ""))
        return lb
    }()
    private let titleLabel = UILabel()
    private let titleSpacer = UIView()
    private let reservationLabel = UILabel()
    private let reservationDetail = UILabel()
    private let reservationSpacer = UIView()
    private lazy var titleStackView = UIStackView(arrangedSubviews: [siteLabel, titleLabel, titleSpacer])
    private lazy var reservationStackView = UIStackView(arrangedSubviews: [reservationLabel, reservationDetail, reservationSpacer])
    private let infoContainer = UIView()
    
    private let divider = UIView()

    private let fiveMinSwitch = AlarmSwitch(min: .five)
    private let tenMinSwitch = AlarmSwitch(min: .ten)
    private let twentyMinSwitch = AlarmSwitch(min: .twenty)
    private let thirtyMinSwitch = AlarmSwitch(min: .thirty)
    private lazy var MinStackView = UIStackView(arrangedSubviews: [fiveMinSwitch, tenMinSwitch, twentyMinSwitch, thirtyMinSwitch])
    
    private let customTimeLabel = UILabel()
    private let customTimeSpacer = UIView()
    private let customTimePicker = UILabel()
    private lazy var customTimeStackView = UIStackView(arrangedSubviews: [customTimeLabel, customTimeSpacer, customTimePicker])
    
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
    
    init(
        viewModel: AlarmViewModel = AlarmViewModel(),
        notice: MusicalNotice
    ) {
        self.viewModel = viewModel
        viewModel.notice = notice
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
        bindRx()
        
        guard let notice = viewModel.notice else { return }
        input.getLocalAlarms.onNext(notice)
    }
    
    private func bindRx() {
        output.localAlarms
            .subscribe { [weak self] alarms in
                guard let self = self else { return }
                
                let times = alarms.map { $0.beforeMin }
  
                self.fiveMinSwitch.minSwitch.isOn = times.contains(where: { $0 == 5 })
                self.tenMinSwitch.minSwitch.isOn = times.contains(where: { $0 == 10 })
                self.twentyMinSwitch.minSwitch.isOn = times.contains(where: { $0 == 20 })
                self.thirtyMinSwitch.minSwitch.isOn = times.contains(where: { $0 == 30 })
                if let customTime = times.first(where: { ![5, 10, 20, 30].contains($0) }) {
                    self.input.setCustomTime.onNext(customTime)
                }
            }
            .disposed(by: disposeBag)
        
        output.customTime
            .subscribe { [weak self] min in
                let hours = min / 60
                let minutes = min % 60
                self?.customTimePicker.text = (min == 0)
                ? "--분 전"
                : (hours == 0 ? "" : "\(hours)시간 ") + "\(minutes)분 전"
            }
            .disposed(by: disposeBag)
    }
    
    private func setGesture() {
        customTimePicker.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let vc = AlarmTimePickerViewController(viewModel: self.viewModel)
                let nav = BottomSheetNavigationController(rootViewController: vc, heigth: 380)
                self.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
//        autoAddNextScheduleButton.rx.tap
//            .subscribe { [weak self] _ in
//                self?.isActiveAutoAddNextSchedule.toggle()
//                self?.toggleButtonImage()
//            }
//            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
                
                var times = [Int]()
                if fiveMinSwitch.minSwitch.isOn { times.append(5) }
                if tenMinSwitch.minSwitch.isOn { times.append(10) }
                if twentyMinSwitch.minSwitch.isOn { times.append(20) }
                if thirtyMinSwitch.minSwitch.isOn { times.append(30) }
                if output.customTime.value != 0 {
                    times.append(output.customTime.value)
                }
                times.sort(by: <)
                
                if viewModel.alarmId != nil {
                    input.upateLocalAlarms.onNext(times)
                } else {
                    input.postLocalAlarms.onNext(times)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        navigationItem.title = "알람 설정"

        siteLabel.site = stringToSiteType(string: viewModel.notice?.siteCategory ?? "")
        titleLabel.setup(text: viewModel.notice?.title?.trimmingCharacters(in: ["\n", "\r", "\t"]) ?? "", color: .gray100, size: 17, weight: .medium)
        titleLabel.numberOfLines = 0
        reservationLabel.setup(text: "예매 일정", color: .gray100, size: 15, weight: .medium)
        reservationDetail.setup(text: viewModel.notice?.openDateTime?.toDateAndTime() ?? "", color: .mainColor, size: 15, weight: .medium)
        
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        titleStackView.alignment = .top
        reservationStackView.axis = .horizontal
        reservationStackView.spacing = 18
        
        divider.backgroundColor = .gray20
        
        MinStackView.axis = .vertical
        MinStackView.spacing = 24
        
        customTimeLabel.setup(text: "사용자 설정", color: .gray100, size: 15, weight: .regular)
        customTimePicker.setup(text: "", color: UIColor("8A8A8A"), size: 15, weight: .regular)
        customTimeStackView.axis = .horizontal
        
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

    private func setAutoLayout() {
        self.view.addSubviews([infoContainer, divider, alarmContainer, buttonContainer])
        infoContainer.addSubviews([titleStackView, reservationStackView])
        alarmContainer.addSubviews([MinStackView, customTimeStackView])
        //alarmContainer.addSubviews([MinStackView, customTimeLabel, autoAddNextScheduleButtonStackView])
        //autoAddNextScheduleButtonStackView.addSubview(autoAddNextScheduleButton)
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
        customTimeStackView.snp.makeConstraints { make in
            make.top.equalTo(MinStackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
//        autoAddNextScheduleButtonStackView.snp.makeConstraints { make in
//            make.top.equalTo(customTimeLabel.snp.bottom).offset(20)
//            make.leading.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//        autoAddNextScheduleButton.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        // buttonContainer
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(alarmContainer.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
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
    
    private func stringToSiteType(string: String) -> Site {
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

class AlarmSwitch: UIView {
    
    let type: LocalAlarmType
    
    private let minLabel = UILabel()
    private let spacer = UIView()
    let minSwitch = UISwitch()
    private lazy var stackView = UIStackView(arrangedSubviews: [minLabel, spacer, minSwitch])
    
    init(min: LocalAlarmType) {
        self.type = min
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        minLabel.setup(text: type.before, color: .gray100, size: 15, weight: .regular)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
