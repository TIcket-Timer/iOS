//
//  LoginViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    
    private let kakaoImageView = UIImageView()
    private let appleImageView = UIImageView()
    private lazy var socialStackView = UIStackView(arrangedSubviews: [kakaoImageView, appleImageView])
    
    private let signupLabel = UILabel()
    private let divier = UIView()
    
    private let smallKakaoImageView = UIImageView()
    private let smallAppleImageView = UIImageView()
    private lazy var smallSocialstackView = UIStackView(arrangedSubviews: [smallKakaoImageView, smallAppleImageView])

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        logoImageView.image = UIImage(named: "splashLogo")
        
        kakaoImageView.backgroundColor = .yellow
        kakaoImageView.snp.makeConstraints { $0.height.equalTo(45) }
        kakaoImageView.layer.cornerRadius = 5
        
        appleImageView.backgroundColor = .black
        appleImageView.snp.makeConstraints { $0.height.equalTo(45) }
        appleImageView.layer.cornerRadius = 5
        
        socialStackView.axis = .vertical
        socialStackView.spacing = 16
        
        signupLabel.setup(text: "회원가입", color: .gray80, size: 13, weight: .regular)
        signupLabel.backgroundColor = .white
        signupLabel.textAlignment = .center
        divier.backgroundColor = .gray40
                
        smallKakaoImageView.backgroundColor = .yellow
        smallKakaoImageView.snp.makeConstraints { $0.height.width.equalTo(50) }
        smallKakaoImageView.layer.cornerRadius = 25
        
        smallAppleImageView.backgroundColor = .black
        smallAppleImageView.snp.makeConstraints { $0.height.width.equalTo(50) }
        smallAppleImageView.layer.cornerRadius = 25
        
        smallSocialstackView.axis = .horizontal
        smallSocialstackView.spacing = 18
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([logoImageView, socialStackView, divier, smallSocialstackView])
        divier.addSubview(signupLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(260)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(125)
        }
        
        socialStackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(133)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
        }
        
        divier.snp.makeConstraints { make in
            make.top.equalTo(socialStackView.snp.bottom).offset(58)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
            make.height.equalTo(1)
        }
        signupLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        
        smallSocialstackView.snp.makeConstraints { make in
            make.top.equalTo(signupLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
    }
}
