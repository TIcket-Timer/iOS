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
    
    private let timeSettingLabel = UILabel()
    private let fiveMinSwitch = AlarmSwitch(min: .five)
    private let tenMinSwitch = AlarmSwitch(min: .ten)
    private let twentyMinSwitch = AlarmSwitch(min: .twenty)
    private let thirtyMinSwitch = AlarmSwitch(min: .thirty)
    private lazy var minStackView = UIStackView(arrangedSubviews: [fiveMinSwitch, tenMinSwitch, twentyMinSwitch, thirtyMinSwitch])
    
    private let divider1 = UIView()
    
    private let soundSettingLabel = UILabel()
    private let soundLabel = UILabel()
    private let soundSpacer = UIView()
    private let changeSoundLabel = UILabel()
    private lazy var soundStackView = UIStackView(arrangedSubviews: [soundLabel, soundSpacer, changeSoundLabel])
    
    private let divider2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
    }
    
    private func setGesture() {
        fiveMinSwitch.minSwitch.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
        
        tenMinSwitch.minSwitch.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
        
        twentyMinSwitch.minSwitch.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
        
        thirtyMinSwitch.minSwitch.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
        
        changeSoundLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "알람 성정"
        
        timeSettingLabel.setup(text: "시간 설정", color: .black, size: 17, weight: .bold)
        minStackView.axis = .vertical
        minStackView.spacing = 17
        
        divider1.backgroundColor = UIColor("#F9F9F9")
        
        soundSettingLabel.setup(text: "소리 설정", color: .black, size: 17, weight: .bold)
        soundLabel.setup(text: "기본음 1", color: .black, size: 17, weight: .regular)
        changeSoundLabel.setup(text: "변경", color: UIColor("#8A8A8A"), size: 15, weight: .regular)
        soundStackView.axis = .horizontal
        soundStackView.distribution = .fill
        
        divider2.backgroundColor = UIColor("#F9F9F9")
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([timeSettingLabel, minStackView, soundSettingLabel, soundStackView, divider1, divider2])
        
        timeSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        minStackView.snp.makeConstraints { make in
            make.top.equalTo(timeSettingLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        divider1.snp.makeConstraints { make in
            make.top.equalTo(minStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        soundSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        soundStackView.snp.makeConstraints { make in
            make.top.equalTo(soundSettingLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        divider2.snp.makeConstraints { make in
            make.top.equalTo(soundStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}
