//
//  SettingsViewModel.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import RxSwift
import RxRelay

class SettingsViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let userService = UserService.shared
    private let authService = AuthService.shared
    
    let input = Input()
    let output = Output()
    
    init() {
        input.getNickName
            .bind(to: output.bindNickName)
            .disposed(by: disposeBag)
    }
    
    struct Input {
        var getUserInfo = PublishRelay<Void>()
        var updatNickname = PublishRelay<String>()
        var getSiteAlarmSettings = PublishSubject<PushAlarmSetting>()
        var updateAllSiteAlarmSettings = PublishSubject<PushAlarmSetting>()
        var logout = PublishSubject<Void>()
        var getNickName = PublishRelay<String>()
        var signout = PublishSubject<Void>()
    }
    struct Output {
        var bindUserInfo = PublishRelay<User>()
        var bindSiteAlarmSettings = PublishRelay<PushAlarmSetting>()
        var logoutSuccess = PublishSubject<Bool>()
        var bindNickName = PublishRelay<String>()
        var signoutSuccess = PublishSubject<Bool>()
    }
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.getUserInfo
            .flatMap { [weak self] _ -> Observable<User> in
                self?.userService.getUserInfo() ?? Observable.empty()
            }
            .bind(to: output.bindUserInfo)
            .disposed(by: disposeBag)
        
        input.updatNickname
            .subscribe { [weak self] nickname in
                self?.userService.updateUserNickname(nickname: nickname)
            }
            .disposed(by: disposeBag)
        
        input.getSiteAlarmSettings
            .flatMap { _ in
                self.userService.getSiteAlarmSettings()
            }
            .bind(to: output.bindSiteAlarmSettings)
            .disposed(by: disposeBag)
        
        input.updateAllSiteAlarmSettings
            .subscribe { [weak self] settings in
                self?.userService.updateAllSiteAlarmSettings(settings: settings)
            }
            .disposed(by: disposeBag)
        
        input.logout
            .subscribe { [weak self] _ in
                self?.authService.logout()
                output.logoutSuccess.onNext(true)
            }
            .disposed(by: disposeBag)
        
        input.signout
            .subscribe { [weak self] _ in
                self?.authService.signout()
                output.signoutSuccess.onNext(true)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
