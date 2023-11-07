//
//  AlarmConfigureViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class AlarmConfigureViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = SettingsViewModel()
    private lazy var input = SettingsViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let interparkSwitch = SiteSwitch(site: .interpark)
    private let melonSwitch = SiteSwitch(site: .melon)
    private let yes24Switch = SiteSwitch(site: .yes24)
    private lazy var siteStackView = UIStackView(arrangedSubviews: [interparkSwitch, melonSwitch, yes24Switch])
    
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    private lazy var ButtonStackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
        bindData()
        
        input.getSiteAlarmSettings.onNext(PushAlarmSetting(interAlarm: false, melonAlarm: false, yesAlarm: false))
    }
    
    private func bindData() {
        output.bindSiteAlarmSettings
            .subscribe { [weak self] settings in
                self?.interparkSwitch.siteSwitch.isOn = settings.interAlarm
                self?.melonSwitch.siteSwitch.isOn = settings.melonAlarm
                self?.yes24Switch.siteSwitch.isOn = settings.yesAlarm
            }
            .disposed(by: disposeBag)
    }
    
    private func setGesture() {
//        interparkSwitch.siteSwitch.rx.tapGesture()
//            .when(.recognized)
//            .subscribe { [weak self] _ in
//
//            }
//            .disposed(by: disposeBag)
//
//        melonSwitch.siteSwitch.rx.tapGesture()
//            .when(.recognized)
//            .subscribe { [weak self] _ in
//
//            }
//            .disposed(by: disposeBag)
//
//        yes24Switch.siteSwitch.rx.tapGesture()
//            .when(.recognized)
//            .subscribe { [weak self] _ in
//
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
                
                let settings = PushAlarmSetting(
                    interAlarm: interparkSwitch.siteSwitch.isOn,
                    melonAlarm: melonSwitch.siteSwitch.isOn,
                    yesAlarm: yes24Switch.siteSwitch.isOn
                )
                input.updateAllSiteAlarmSettings.onNext(settings)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "새로 오픈한 공연정보 알림 받기"
        
        siteStackView.axis = .vertical
        siteStackView.spacing = 24
        
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
        self.view.addSubviews([siteStackView, ButtonStackView])
        
        siteStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
 
        ButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(siteStackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(48)
        }
    }
}

class SiteSwitch: UIView {
    
    let site: Site
    
    private let siteLabel = UILabel()
    private let spacer = UIView()
    let siteSwitch = UISwitch()
    private lazy var stackView = UIStackView(arrangedSubviews: [siteLabel, spacer, siteSwitch])
    
    init(site: Site) {
        self.site = site
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        siteLabel.setup(text: site.ticket, color: .gray100, size: 15, weight: .regular)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
