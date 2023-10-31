//
//  TabBarViewModel.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//


import RxSwift

final class TabBarViewModel: ViewModelType {
	
	private let disposeBag = DisposeBag()
	private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
	
	func transform(input: Input) -> Output {
        let output = Output()
        
        input.checkLogin
            .flatMap { _ -> Observable<Bool> in
                return LoginService.shared.checkLogin()
            }
            .subscribe { isLogin in
                print("[로그인 상태: \(isLogin)]")
                if isLogin == true {
                    output.showLogin.onNext(true)
                } else {
                    output.showLogin.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        return output
	}
}

extension TabBarViewModel {
	struct Input {
        let checkLogin = PublishSubject<Void>()
	}
	struct Output {
        let showLogin = PublishSubject<Bool>()
	}
}
