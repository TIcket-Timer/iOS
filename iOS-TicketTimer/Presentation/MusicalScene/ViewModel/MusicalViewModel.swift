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
    
    var selectedNotice: MusicalNotice? = nil
    var selectedMusical: Musicals? = nil {
        didSet {
            guard let musical = selectedMusical else { return }
            addViewdMusicalHistory(musical: musical)
        }
    }
    
    var query = "" {
        didSet {
            addSearchHistory(query: query)
        }
    }
    
    struct Input {
        var getPopularMusicals = PublishSubject<Platform>()
        var getSearchHistory = PublishSubject<[SearchHistorySection]>()
        var getMuscialHistory = PublishSubject<[MusicalsSection]>()
        var getNoticSearch = PublishSubject<String>()
        var getMusicalSearch = PublishSubject<String>()
        var getMusicalSearchWithSite = PublishSubject<(Platform, String)>()
    }
    
    struct Output {
        var bindPopularMusicals = PublishSubject<[MusicalsSection]>()
        var bindSearchHistory = PublishSubject<[SearchHistorySection]>()
        var bindMuscialHistory = PublishSubject<[MusicalsSection]>()
        var bindNoticeLimitedSearch = PublishSubject<[MusicalNoticeSection]>()
        var bindNoticeAllSearch = PublishSubject<[MusicalNoticeSection]>()
        var bindMusicalLimitedSearch = PublishSubject<[MusicalsSection]>()
        var bindMusicalAllSearch = PublishSubject<[MusicalsSection]>()
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
        
        input.getNoticSearch
            .observe(on: MainScheduler.instance)
            .flatMap { query -> Observable<Response<[MusicalNotice]>> in
                return self.musicalService.searchMusicalNotices(query: query)
            }
            .subscribe { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    guard let result = response.result else { return }
                    
                    var limited = MusicalNoticeSection(items: [])
                    limited.items.append(contentsOf: result.prefix(2))
                    output.bindNoticeLimitedSearch.onNext([limited])
                    
                    var all = MusicalNoticeSection(items: [])
                    all.items.append(contentsOf: result)
                    output.bindNoticeAllSearch.onNext([all])
                } else {
                    print("[status code is not 200]")
                }
            }
            .disposed(by: disposeBag)
        
        input.getMusicalSearch
            .observe(on: MainScheduler.instance)
            .flatMap { query -> Observable<Response<[Musicals]>> in
                return self.musicalService.searchMusicalsWithAllSites(query: query)
                //return self.musicalService.getPopularMusicals(platform: .interpark)
            }
            .subscribe { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    guard let result = response.result else { return }
                    
                    var limited = MusicalsSection(items: [])
                    limited.items.append(contentsOf: result.prefix(2))
                    output.bindMusicalLimitedSearch.onNext([limited])
                    
                    var all = MusicalsSection(items: [])
                    all.items.append(contentsOf: result)
                    output.bindMusicalAllSearch.onNext([all])
                } else {
                    print("[status code is not 200]")
                }
            }
            .disposed(by: disposeBag)
        
        input.getMusicalSearchWithSite
            .observe(on: MainScheduler.instance)
            .flatMap { site, query -> Observable<Response<[Musicals]>> in
                return self.musicalService.searchMusicalsWithSite(platform: site, query: query)
            }
            .subscribe { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    guard let result = response.result else { return }
                    var section = MusicalsSection(items: [])
                    section.items.append(contentsOf: result)
                    output.bindMusicalAllSearch.onNext([section])
                } else {
                    print("[status code is not 200]")
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    func addSearchHistory(query: String) {
        userDefaultService.addSearchHistory(query: query)
    }
    
    func deleteSearchHistory(query: String) {
        userDefaultService.deleteSearchHistory(query: query)
    }
    
    func addViewdMusicalHistory(musical: Musicals) {
        userDefaultService.updateMusicalHistory(musical: musical)
    }
    
    func showMusicalDetailViewController(viewController: UIViewController) {
        viewController.navigationItem.searchController?.isActive = false

        guard let musical = self.selectedMusical else { return }
        self.addViewdMusicalHistory(musical: musical)
        let vc = MusicalDetailViewController(musical: musical)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
        //presentAlarmSettingViewController(viewController: viewController)
    }
    
    func presentAlarmSettingViewController(viewController: UIViewController) {
        guard let notice = self.selectedNotice else { return }
        let vc = AlarmSettingViewController(notice: notice)
//        let vc = AlarmSettingViewController(notice: MusicalNotice(id: "1", siteCategory: "MELON", openDateTime: "202310202000", title: "타이틀", url: ""))
        vc.navigationItem.title = "알람 설정"
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .automatic
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        viewController.present(navigationController, animated: true, completion: nil)
    }
}

