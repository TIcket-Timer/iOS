//
//  ShowViewModel.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import RxSwift

class MusicalViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let musicalService = MusicalService.shared
    
    var musicalsSection = MusicalsSection(items: [])
    var selectedMusical: Musicals? = nil
    
    struct Input {
        var getPopularMusicals = PublishSubject<Platform>()
    }
    
    struct Output {
        var bindPopularMusicals = PublishSubject<[MusicalsSection]>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        var section = MusicalsSection(items: [])

        input.getPopularMusicals
            .observe(on: backgroundScheduler)
            .flatMap { platform -> Observable<Response<[Musicals]>> in
                return self.musicalService.getPopularMusicals(platform: platform)
            }
            .subscribe(onNext: { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    guard let result = response.result else { return }
                    section.items.removeAll()
                    section.items.append(contentsOf: result)
                    output.bindPopularMusicals.onNext([section])
                } else {
                    print("[status code is not 200]")
                }
            })
            .disposed(by: disposeBag)

        return output
    }
}

