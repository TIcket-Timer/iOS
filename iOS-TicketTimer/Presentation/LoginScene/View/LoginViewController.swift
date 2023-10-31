//
//  LoginViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = LoginViewModel()
    
    private let logoImageView = UIImageView()
    
    private let kakaoRecButton = UIImageView()
    private let appleRecButton = UIImageView()
    private lazy var recButtonStackView = UIStackView(arrangedSubviews: [kakaoRecButton, appleRecButton])
    
    private let signupLabel = UILabel()
    private let divier = UIView()
    
    private let kakaoCirButton = UIImageView()
    private let appleCirButton = UIImageView()
    private lazy var cirButtonSocialstackView = UIStackView(arrangedSubviews: [kakaoCirButton, appleCirButton])
    
    private var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        setBinding()
    }
    
    private func setBinding() {
        kakaoRecButton.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                self?.viewModel.input.login.onNext(.kakao)
            }
            .disposed(by: disposeBag)
        
        appleRecButton.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let request = ASAuthorizationAppleIDProvider().createRequest()
                request.requestedScopes = [.fullName, .email]
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
                controller.performRequests()
            }
            .disposed(by: disposeBag)
        
        kakaoCirButton.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                self?.viewModel.input.login.onNext(.kakao)
            }
            .disposed(by: disposeBag)
        
        appleCirButton.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                self?.viewModel.input.login.onNext(.kakao)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.loginSuccess
            .subscribe(onNext: { success in
                if success {
                    let vc = TabBarViewController()
                    PresentationManager.shared.changeRootVC(vc)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        view.backgroundColor = .white
        
        logoImageView.image = UIImage(named: "splashLogo")
        
        kakaoRecButton.image = UIImage(named: "kakaoRectangle")
        kakaoRecButton.snp.makeConstraints { $0.height.equalTo(45) }
        kakaoRecButton.layer.cornerRadius = 5
        
        appleRecButton.image = UIImage(named: "appleRectangle")
        appleRecButton.snp.makeConstraints { $0.height.equalTo(45) }
        appleRecButton.layer.cornerRadius = 5
        
        recButtonStackView.axis = .vertical
        recButtonStackView.spacing = 16
        
        signupLabel.setup(text: "회원가입", color: .gray80, size: 13, weight: .regular)
        signupLabel.backgroundColor = .white
        signupLabel.textAlignment = .center
        divier.backgroundColor = .gray40
        
        kakaoCirButton.image = UIImage(named: "kakaoCircle")
        kakaoCirButton.snp.makeConstraints { $0.height.width.equalTo(50) }
        kakaoCirButton.layer.cornerRadius = 25
        
        appleCirButton.image = UIImage(named: "appleCircle")
        appleCirButton.snp.makeConstraints { $0.height.width.equalTo(50) }
        appleCirButton.layer.cornerRadius = 25
        
        cirButtonSocialstackView.axis = .horizontal
        cirButtonSocialstackView.spacing = 18
    }
}

extension LoginViewController {
    private func setLayout() {
        self.view.addSubviews([logoImageView, recButtonStackView, divier, cirButtonSocialstackView])
        divier.addSubview(signupLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(260)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(125)
        }
        
        recButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(133)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
        }
        
        divier.snp.makeConstraints { make in
            make.top.equalTo(recButtonStackView.snp.bottom).offset(58)
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
            make.height.equalTo(1)
        }
        signupLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        
        cirButtonSocialstackView.snp.makeConstraints { make in
            make.top.equalTo(signupLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let appleIDToken = credential.identityToken else {
                print("identityToken error")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("appleIDToken error")
                return
            }
            
            print("[idTokenString: \(idTokenString)]")
            //viewModel.input.login.onNext(.apple)
        }
    }
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) { }
}
