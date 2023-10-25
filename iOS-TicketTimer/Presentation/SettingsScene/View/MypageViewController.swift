//
//  MypageViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class MypageViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = SettingsViewModel()
    private lazy var input = SettingsViewModel.Input()
    private lazy var output = viewModel.transform(input: input)

    private let nicknameLabel = UILabel()
    private let emailLabel = UILabel()
    private lazy var userStackView = UIStackView(arrangedSubviews: [nicknameLabel, emailLabel])
    
    private let divider = UIView()
    
    private let socialLabel = UILabel()
    private let socialSpacer = UIView()
    private let socialImageView = UIImageView()
    private lazy var socialStackView = UIStackView(arrangedSubviews: [socialLabel, socialSpacer, socialImageView])
    
    private let settingUsernameLabel = SettingDetail(title: "닉네임 설정")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        input.getUserInfo.accept(User(nickname: "", email: ""))
    }
    
    private func bindData() {
        output.bindUserInfo
            .subscribe { [weak self] user in
                self?.nicknameLabel.text = user.nickname
                self?.emailLabel.text = user.email
            }
            .disposed(by: disposeBag)
    }
    
    private func setGesture() {
        settingUsernameLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = ChangeUsernameViewController()
                let nav = BottomSheetNavigationController(rootViewController: vc, heigth: 260)
                self?.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "마이페이지"
        
        nicknameLabel.setup(text: "닉네임", color: .black, size: 17, weight: .bold)
        emailLabel.setup(text: "이메일", color: UIColor("8A8A8A"), size: 15, weight: .regular)
        
        userStackView.axis = .vertical
        userStackView.alignment = .leading
        userStackView.spacing = 7
        
        divider.backgroundColor = UIColor("#F9F9F9")
        
        socialLabel.setup(text: "소셜 로그인", color: .black, size: 17, weight: .regular)
        socialImageView.image = UIImage(systemName: "heart.circle")
        socialImageView.tintColor = .yellow
        socialStackView.axis = .horizontal
        socialStackView.distribution = .fill
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([userStackView, divider, socialStackView, settingUsernameLabel])
        
        userStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(35)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        socialStackView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        settingUsernameLabel.snp.makeConstraints { make in
            make.top.equalTo(socialStackView.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}

