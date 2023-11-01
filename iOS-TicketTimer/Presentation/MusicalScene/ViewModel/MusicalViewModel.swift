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
    private let searchHistoryService = SearchHistoryService.shared
    
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
        var bindNoticeSearch = PublishSubject<[MusicalNoticeSection]>()
        var bindMusicalSearch = PublishSubject<[MusicalsSection]>()
    }
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.getPopularMusicals
            .observe(on: backgroundScheduler)
            .flatMap { platform -> Observable<[Musicals]> in
                return self.musicalService.getPopularMusicals(platform: platform)
            }
            .subscribe(onNext: { musicals in
                var section = MusicalsSection(items: [])
                section.items.append(contentsOf: musicals)
                output.bindPopularMusicals.onNext([section])
            })
            .disposed(by: disposeBag)
        
        input.getSearchHistory
            .observe(on: MainScheduler.instance)
            .flatMap { _ -> Observable<[String]> in
                return self.searchHistoryService.getSearchHistory()
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
                return self.searchHistoryService.getMusicalHistory()
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
                    var section = MusicalNoticeSection(items: [])
                    section.items.append(contentsOf: result)
                    output.bindNoticeSearch.onNext([section])
                } else {
                    print("[\(response.code)] \(response.message)")
                }
            }
            .disposed(by: disposeBag)
        
        input.getMusicalSearch
            .observe(on: MainScheduler.instance)
            .flatMap { query -> Observable<Response<[Musicals]>> in
                return self.musicalService.searchMusicalsWithAllSites(query: query)
            }
            .subscribe { response in
                print("[\(response.code)] \(response.message)")
                
                if response.code == 200 {
                    guard let result = response.result else { return }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let sortedMusicals = result.sorted { firstElement, secondElement in
                        guard let firstDate = dateFormatter.date(from: firstElement.startDate ?? ""),
                              let secondDate = dateFormatter.date(from: secondElement.startDate ?? "")
                        else { return false }
                        return firstDate > secondDate
                    }
                    
                    var section = MusicalsSection(items: [])
                    section.items.append(contentsOf: sortedMusicals)
                    output.bindMusicalSearch.onNext([section])
                } else {
                    print("[\(response.code)] \(response.message)")
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
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let sortedMusicals = result.sorted { firstElement, secondElement in
                        guard let firstDate = dateFormatter.date(from: firstElement.startDate ?? ""),
                              let secondDate = dateFormatter.date(from: secondElement.startDate ?? "")
                        else { return false }
                        return firstDate > secondDate
                    }
                    
                    var section = MusicalsSection(items: [])
                    section.items.append(contentsOf: sortedMusicals)
                    output.bindMusicalSearch.onNext([section])
                } else {
                    print("[\(response.code)] \(response.message)")
                }
            }
            .disposed(by: disposeBag)
        
        return output
    }
    
    func addSearchHistory(query: String) {
        searchHistoryService.addSearchHistory(query: query)
    }
    
    func deleteSearchHistory(query: String) {
        searchHistoryService.deleteSearchHistory(query: query)
    }
    
    func addViewdMusicalHistory(musical: Musicals) {
        searchHistoryService.updateMusicalHistory(musical: musical)
    }
    
    func showMusicalDetailViewController(viewController: UIViewController) {
        viewController.navigationItem.searchController?.isActive = false

        guard let musical = self.selectedMusical else { return }
        self.addViewdMusicalHistory(musical: musical)
        let vc = MusicalDetailViewController(musical: musical)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentAlarmSettingViewController(viewController: UIViewController) {
        guard let notice = self.selectedNotice else { return }
        let vc = AlarmSettingViewController(notice: notice)
        let nav = BottomSheetNavigationController(rootViewController: vc, heigth: 650)
        nav.modalPresentationStyle = .automatic
        
        viewController.present(nav, animated: true, completion: nil)
    }
}

