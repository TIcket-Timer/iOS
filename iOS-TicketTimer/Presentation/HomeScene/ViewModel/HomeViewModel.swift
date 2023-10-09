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
		var getDeadlineMusicalNotices	    : ReplaySubject<(page: Int, size: Int)>
		var getLatestMusicals				: ReplaySubject<Execution<Any>>
        var loadMoreMusicals                : ReplaySubject<Execution<Any>>
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
        
        var page: Int = 0
        let size: Int = 5
        var hasMoreData: Bool = false
        var isLoading: Bool = false
        var section = MusicalsSection(items: [])
    
        // MARK: - [예매 임박]
		input.getDeadlineMusicalNotices
            .observe(on: backgroundScheduler)
			.map { params in
				let (page, size) = params
				return self.musicalService.getDeadlineMusicalNotices(page: page, size: size)
			}
			.subscribe(onNext: { _ in
				
			}, onError: { error in
				
			})
			.disposed(by: bag)
		
        // MARK: - [공연 오픈 소식] 뮤지컬 정보 요청
		input.getLatestMusicals
            .observe(on: backgroundScheduler)
			.flatMap { _ -> Observable<Response<[Musicals]>> in
                print("[공연 오픈 소식] page: \(page), size: \(size), hasMoreData: \(hasMoreData)")
                isLoading = true
                
				return self.musicalService.getLatestMusicals(page: page, size: size)
			}
			.subscribe(onNext: { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    if let result = response.result {
                        section.items.append(contentsOf: result.map { $0 })
                        
                        if result.count == size {
                            hasMoreData = true
                            page += 1
                        }
                    }
                    
                    output.bindLatestMusicals.onNext([section])
                } else {
                    
                }
                
                isLoading = false
            }, onError: { error in
                print("\(error)")
                isLoading = false
            })
			.disposed(by: bag)
        
        // MARK: - [공연 오픈 소식] 페이징 처리
        input.loadMoreMusicals
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in hasMoreData && !isLoading }
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
