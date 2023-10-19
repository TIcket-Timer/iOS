//
//  UserDefaultService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/17.
//

import RxSwift

class UserDefaultService {
    static let shared = UserDefaultService()
    
    //MARK: - 최근 검색기록 가져오기
    func getSearchHistory() -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            if let searchHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
                if !searchHistory.isEmpty {
                    observer.onNext(searchHistory)
                } else {
                    observer.onNext(["검색 내역이 없습니다."])
                }
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: - 최근 검색기록 저장
    func addSearchHistory(query: String) {
        var searchHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? []
        
        searchHistory.removeAll(where: { $0 == query })
        searchHistory.insert(query, at: 0)
        
        if searchHistory.count > 10 {
            searchHistory.removeLast()
        }
        
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    //MARK: - 최근 검색기록 삭제
    func deleteSearchHistory(query: String) {
        var searchHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? []

        searchHistory.removeAll(where: { $0 == query })
        
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    	
    //MARK: - 최근 본 뮤지컬 가져오기
    func getMusicalHistory() -> Observable<[Musicals]> {
        return Observable.create { observer -> Disposable in
            if let data = UserDefaults.standard.value(forKey:"musicalHistory") as? Data {
                let musicalHistory = try! PropertyListDecoder().decode([Musicals].self, from: data)
                observer.onNext(musicalHistory)
            } else {
                observer.onNext([])
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    //MARK: - 최근 본 뮤지컬 저장
    func updateMusicalHistory(musical: Musicals) {
        var musicalHistory: [Musicals] = []
        
        if let data = UserDefaults.standard.value(forKey:"musicalHistory") as? Data {
            musicalHistory = try! PropertyListDecoder().decode([Musicals].self, from: data)
        }
        
        musicalHistory.removeAll(where: { $0 == musical })
        musicalHistory.insert(musical, at: 0)
        
        if musicalHistory.count > 10 {
            musicalHistory.removeLast()
        }
        
        UserDefaults.standard.set(try! PropertyListEncoder().encode(musicalHistory), forKey:"musicalHistory")
    }
    
    //MARK: - 공지 알람 정보 가져오기
    func getLocalAlarmData(notice: MusicalNotice) -> [LocalAlarm] {
        let noticeId = notice.id
        var alarms: [LocalAlarm] = []

        if let data = UserDefaults.standard.value(forKey:"noticeAlarm") as? Data {
            alarms = try! PropertyListDecoder().decode([LocalAlarm].self, from: data)
        }
        
        return alarms.filter({ $0.noticeId == noticeId })
    }
    
    //MARK: - 공지 알람 정보 저장하기
    func saveLocalAlarmData(alarms newAlarms: LocalAlarm) {
        var alarms: [LocalAlarm] = []
        
        if let data = UserDefaults.standard.value(forKey:"noticeAlarm") as? Data {
            alarms = try! PropertyListDecoder().decode([LocalAlarm].self, from: data)
        }
        
        alarms.append(newAlarms)
        
        UserDefaults.standard.set(try! PropertyListEncoder().encode(alarms), forKey:"noticeAlarm")
    }
    
    //MARK: - 공지 알람 정보 삭제하기
    func deleteLocalAlarmData(alarms deletedAlarms: [LocalAlarm]) {
        var alarms: [LocalAlarm] = []
        
        if let data = UserDefaults.standard.value(forKey:"noticeAlarm") as? Data {
            alarms = try! PropertyListDecoder().decode([LocalAlarm].self, from: data)
        }
        
        let deletedIds = Set(deletedAlarms.map { $0.noticeId })
        
        alarms.removeAll(where: { deletedIds.contains($0.noticeId) })
        
        UserDefaults.standard.set(try! PropertyListEncoder().encode(alarms), forKey:"noticeAlarm")
    }
}
