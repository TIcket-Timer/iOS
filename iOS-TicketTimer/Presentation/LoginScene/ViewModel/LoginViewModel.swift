//
//  LoginViewModel.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import RxSwift

class LoginViewModel {
    
    private let disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let loginService = LoginService.shared
    private let tokenService = TokenService.shared
    
    init() {
        input.login
            .flatMap { [weak self] type -> Observable<SocialLoginResult> in
                return self?.loginService.login(with: type) ?? Observable.empty()
            }
            .flatMap { [weak self] result -> Observable<LoginResult> in
                self?.loginService.saveSocialLoginType(result.SocialLoginType.rawValue)
                return self?.loginService.sendToken(result.SocialLoginType, with: result.token) ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] result in
                self?.tokenService.saveAccessToken(with: result.accessToken)
                self?.tokenService.saveRefreshToken(with: result.refreshToken)
                print("[저장 accessToken: \(result.accessToken)]")
                print("[저장 refreshToken: \(result.refreshToken)]")
                self?.output.loginSuccess.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel {
    struct Input {
        var login = PublishSubject<SocialLoginType>()
    }
    struct Output {
        var loginSuccess = PublishSubject<Bool>()
    }
}
