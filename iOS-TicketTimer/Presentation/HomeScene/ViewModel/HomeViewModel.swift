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
		var getDeadlineMusicalNotices	    : ReplaySubject<Execution<Any>>
		var getLatestMusicals				: ReplaySubject<Execution<Any>>
        var loadMoreMusicals                : ReplaySubject<Execution<Any>>
        var loadMoreMusicalNotices          : ReplaySubject<Execution<Any>>
    }
    
    struct Output {
		var bindDeadlineMusicalNotices		: ReplaySubject<[MusicalNoticeSection]>
		var bindLatestMusicals      	    : ReplaySubject<[MusicalsSection]>
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            bindDeadlineMusicalNotices: .create(bufferSize: 1),
            bindLatestMusicals: .create(bufferSize: 1)
        )
	
		var musicalPage: Int = 0
		let musicalSize: Int = 5
        var musicalSection = MusicalsSection(items: [])
		var musicalHasMoreData: Bool = false
		var musicalIsLoading: Bool = false
		
		var musicalNoticePage: Int = 0
//		let musicalNoticeSize: Int = 3
		let musicalNoticeSize: Int = 0
        var musicalNoticeSection = MusicalNoticeSection(items: [])
		var musicalNoticeHasMoreData: Bool = false
		var musicalNoticeIsLoading: Bool = false
    
        // MARK: - [예매 임박]
		input.getDeadlineMusicalNotices
            .observe(on: backgroundScheduler)
			.flatMap { _ in
				musicalNoticeIsLoading = true
				
				return self.musicalService.getDeadlineMusicalNotices(page: musicalNoticePage, size: musicalNoticeSize)
			}
			.subscribe(onNext: { response in
				print("[\(response.code)] \(response.message)")
				
				if response.code == 200 {
					if let result = response.result {
						musicalNoticeSection.items.append(contentsOf: result.map { $0 })
						
						if result.count == musicalNoticeSize {
							musicalNoticeHasMoreData = true
							musicalNoticePage += 1
						}
					}
					
					output.bindDeadlineMusicalNotices.onNext([musicalNoticeSection])
				} else {
					
				}
			}, onError: { error in
				print("\(error)")
			})
			.disposed(by: bag)
		
        // MARK: - [공연 오픈 소식] 뮤지컬 정보 요청
		input.getLatestMusicals
            .observe(on: backgroundScheduler)
			.flatMap { _ -> Observable<Response<[Musicals]>> in
				musicalIsLoading = true
                
				return self.musicalService.getLatestMusicals(page: musicalPage, size: musicalSize)
			}
			.subscribe(onNext: { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    if let result = response.result {
						musicalSection.items.append(contentsOf: result.map { $0 })
                        
                        if result.count == musicalSize {
							musicalHasMoreData = true
							musicalPage += 1
                        }
                    }
                    
                    output.bindLatestMusicals.onNext([musicalSection])
                } else {
                    
                }
                
				musicalIsLoading = false
            }, onError: { error in
                print("\(error)")
				musicalIsLoading = false
            })
			.disposed(by: bag)
		
		// MARK: - [예매 임박] 페이징 처리 
		input.loadMoreMusicalNotices
			.throttle(.seconds(1), scheduler: MainScheduler.instance)
			.filter { _ in musicalNoticeHasMoreData && !musicalNoticeIsLoading }
			.observe(on: backgroundScheduler)
			.bind(to: input.getDeadlineMusicalNotices)
			.disposed(by: bag)
        
        // MARK: - [공연 오픈 소식] 페이징 처리
        input.loadMoreMusicals
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in musicalHasMoreData && !musicalIsLoading }
            .observe(on: backgroundScheduler)
            .bind(to: input.getLatestMusicals)
            .disposed(by: bag)
		
		return output
    }
}

// MARK: - [예매 임박] Rx DataSource
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

// MARK: - [공연 오픈 소식] Rx DataSource
struct MusicalsSection {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

extension MusicalsSection: SectionModelType {
    typealias Item = Musicals
    
    init(original: MusicalsSection, items: [Musicals]) {
        self = original
        self.items = items
    }
}
