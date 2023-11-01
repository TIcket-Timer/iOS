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

        return output
	}
}

extension TabBarViewModel {
	struct Input {
	}
	struct Output {
	}
}
