//
//  HomeViewModel.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import RxSwift
import RxDataSources

class HomeViewModel: ViewModelType {
	private let bag = DisposeBag()
	private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
	private let musicalService = MusicalService.shared
	
    struct Input {
		var getDeadlineMusicals				: ReplaySubject<(page: Int, size: Int)>
		var getLatestMusicals				: ReplaySubject<(page: Int, size: Int)>
    }
    
    struct Output {
		var bindDeadlineMusicalsData		: ReplaySubject<[MusicalNoticeSection]>
		var bindLatestMusicalsData		    : ReplaySubject<[MusicalNoticeSection]>
    }
    
    func transform(input: Input) -> Output {
		
		input.getDeadlineMusicals
			.map { params in
				let (page, size) = params
				return self.musicalService.getDeadlineMusicals(page: page, size: size)
			}
			.subscribe(onNext: { _ in
				
			}, onError: { error in
				
			})
			.disposed(by: bag)
		
		input.getLatestMusicals
			.map { params -> Observable<Response<MusicalNotice>> in
				let (page, size) = params
				return self.musicalService.getLatestMusicals(page: page, size: size)
			}
			.subscribe(onNext: { response in
				if response.result
			})
			.disposed(by: bag)
		
		return Output(
			bindDeadlineMusicalsData: .create(bufferSize: 1),
			bindLatestMusicalsData: .create(bufferSize: 1)
		)
    }
}

// MARK: - Rx DataSource
struct MusicalNoticeSection {
	var items: [Item]
	
	init(items: [Item]) {
		self.items = items
	}
}

extension MusicalNoticeSection: SectionModelType {
	typealias Item = MusicalNotice
	
	init(original: MusicalNoticeSection, items: [MusicalNotice]) {
		self = original
		self.items = items
	}
}
