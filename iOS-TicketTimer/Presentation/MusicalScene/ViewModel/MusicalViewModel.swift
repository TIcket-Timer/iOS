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
    private let userDefaultService = UserDefaultService.shared
    
    var selectedMusical: Musicals? = nil {
        didSet {
            guard let musical = selectedMusical else { return }
            updateViewdMusicalHistory(musical: musical)
        }
    }
    
    struct Input {
        var getPopularMusicals = PublishSubject<Platform>()
        var getSearchHistory = PublishSubject<[SearchHistorySection]>()
        var getMuscialHistory = PublishSubject<[MusicalsSection]>()
    }
    
    struct Output {
        var bindPopularMusicals = PublishSubject<[MusicalsSection]>()
        var bindSearchHistory = PublishSubject<[SearchHistorySection]>()
        var bindMuscialHistory = PublishSubject<[MusicalsSection]>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.getPopularMusicals
            .observe(on: backgroundScheduler)
            .flatMap { platform -> Observable<Response<[Musicals]>> in
                return self.musicalService.getPopularMusicals(platform: platform)
            }
            .subscribe(onNext: { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    guard let result = response.result else { return }
                    var section = MusicalsSection(items: [])
                    section.items.append(contentsOf: result)
                    output.bindPopularMusicals.onNext([section])
                } else {
                    print("[status code is not 200]")
                }
            })
            .disposed(by: disposeBag)
        
        input.getSearchHistory
            .observe(on: MainScheduler.instance)
            .flatMap { _ -> Observable<[String]> in
                return self.userDefaultService.getSearchHistory()
            }
            .subscribe(onNext: { searches in
                var section = SearchHistorySection(items: [])
                section.items.append(contentsOf: searches.prefix(5))
                output.bindSearchHistory.onNext([section])
            })
            .disposed(by: disposeBag)
        
        input.getMuscialHistory
            .observe(on: MainScheduler.instance)
            .flatMap { _ -> Observable<[Musicals]> in
                return self.userDefaultService.getMusicalHistory()
            }
            .subscribe(onNext: { musicals in
                var section = MusicalsSection(items: [])
                section.items.append(contentsOf: musicals)
                output.bindMuscialHistory.onNext([section])
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
//    func getSearchHistory() -> [String] {
//        return userDefaultService.getSearchHistory()
//    }
    
    func addSearchHistory(query: String) {
        userDefaultService.addSearchHistory(query: query)
    }
    
    func deleteSearchHistory(query: String) {
        userDefaultService.deleteSearchHistory(query: query)
    }
    
//    func getMusicalHistory() -> [Musicals] {
//        let musicals = userDefaultService.getMusicalHistory()
//        return userDefaultService.getMusicalHistory()
//    }
    
    func updateViewdMusicalHistory(musical: Musicals) {
        userDefaultService.updateMusicalHistory(musical: musical)
    }
    
    func showMusicalDetailViewController(viewController: UIViewController) {
        guard let musical = self.selectedMusical else { return }
        let vc = MusicalDetailViewController(musical: musical)
        viewController.navigationController?.pushViewController(vc, animated: true)
        self.updateViewdMusicalHistory(musical: musical)
    }
    
    func presentAlarmSettingViewController(viewController: UIViewController, at: Int) {
        let vc = AlarmSettingViewController(platform: .interpark)
        vc.navigationItem.title = "알람 설정"
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .automatic
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        viewController.present(navigationController, animated: true, completion: nil)
    }
}

