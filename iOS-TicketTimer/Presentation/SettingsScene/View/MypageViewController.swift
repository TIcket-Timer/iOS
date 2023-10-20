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

    private let userImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let userSpacer = UIView()
    private lazy var userStackView = UIStackView(arrangedSubviews: [userImageView, usernameLabel, userSpacer])
    
    private let divider = UIView()
    
    private let socialLabel = UILabel()
    private let socialSpacer = UIView()
    private let socialImageView = UIImageView()
    private lazy var socialStackView = UIStackView(arrangedSubviews: [socialLabel, socialSpacer, socialImageView])
    
    private let settingUsernameLabel = UILabel()
    private let settingUserimageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
    }
    
    private func setGesture() {
        settingUsernameLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = ChangeUsernameViewController()
                let nav = UINavigationController(rootViewController: vc)
                if let sheet = nav.sheetPresentationController {
                    sheet.prefersGrabberVisible = true
                }
                self?.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        settingUserimageLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "마이페이지"
        
        userImageView.image = UIImage(systemName: "person.circle")
        userImageView.tintColor = .gray
        userImageView.backgroundColor = .yellow
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 40
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        usernameLabel.setup(text: "닉네임", color: .black, size: 17, weight: .bold)
        userStackView.axis = .horizontal
        userStackView.alignment = .center
        userStackView.distribution = .fill
        userStackView.spacing = 24
        
        divider.backgroundColor = UIColor("#F9F9F9")
        
        socialLabel.setup(text: "소셜 로그인", color: .black, size: 17, weight: .regular)
        socialImageView.image = UIImage(systemName: "heart.circle")
        socialImageView.tintColor = .orange
        socialStackView.axis = .horizontal
        socialStackView.distribution = .fill
        
        settingUsernameLabel.setup(text: "닉네임 설정", color: .black, size: 17, weight: .regular)
        settingUserimageLabel.setup(text: "프로필 사진 변경", color: .black, size: 17, weight: .regular)
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([userStackView, divider, socialStackView, settingUsernameLabel, settingUserimageLabel])
        
        userStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
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
        
        settingUserimageLabel.snp.makeConstraints { make in
            make.top.equalTo(settingUsernameLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}
