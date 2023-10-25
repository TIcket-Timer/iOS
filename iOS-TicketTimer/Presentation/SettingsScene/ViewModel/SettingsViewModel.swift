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
    
    struct Input {
        var getUserInfo = PublishRelay<User>()
        var updatNickname = PublishRelay<String>()
        var getSiteAlarmSettings = PublishSubject<PushAlarmSetting>()
        var updateAllSiteAlarmSettings = PublishSubject<PushAlarmSetting>()
    }
    struct Output {
        var bindUserInfo = PublishRelay<User>()
        var bindSiteAlarmSettings = PublishRelay<PushAlarmSetting>()
    }
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.getUserInfo
            .flatMap { _ in
                self.userService.getUserInfo()
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
        
        return output
    }
}
