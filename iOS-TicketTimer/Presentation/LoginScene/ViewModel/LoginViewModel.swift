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
    private let authService = AuthService.shared
    private let tokenService = TokenService.shared
    
    init() {
        input.socialLogin
            .flatMap { [weak self] type -> Observable<SocialLoginResult> in
                return self?.authService.login(with: type) ?? Observable.empty()
            }
            .flatMap { [weak self] result -> Observable<LoginResult> in
                self?.authService.saveSocialLoginType(result.SocialLoginType.rawValue)
                return self?.authService.sendToken(result.SocialLoginType, with: result.token) ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] result in
                self?.tokenService.saveAccessToken(with: result.accessToken)
                self?.tokenService.saveRefreshToken(with: result.refreshToken)
                self?.output.socialLoginSuccess.onNext(true)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel {
    struct Input {
        var socialLogin = PublishSubject<SocialLoginType>()
    }
    struct Output {
        var socialLoginSuccess = PublishSubject<Bool>()
    }
}

