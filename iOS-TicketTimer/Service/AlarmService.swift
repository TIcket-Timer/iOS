//
//  AlarmService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/23.
//

import RxSwift
import Alamofire

class AlarmService {
    static let shared = AlarmService()
    let userNotificationService = UserNotificationService.shared
    
    private let baseUrl = Server.baseUrl.rawValue
    
    func getAllAlarms() -> Observable<[Alarm]> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/alarms"
        urlComponents?.path = path

        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
                
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]
        
        return Observable.create { observer -> Disposable in
            AF.request(url, headers: header)
                .responseDecodable(of: Response<[Alarm]>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        if response.code == 201 {
                            guard let alarms = response.result else { return }
                            observer.onNext(alarms)
                            observer.onCompleted()
                        } else {
                            print("[\(response.code)] \(response.message)")
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[getAllAlarms 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }

            return Disposables.create()
        }
    }

    func getLocalAlarms(notice: MusicalNotice) -> Observable<[LocalAlarm]> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/alarms"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]
        
        return Observable.create { observer -> Disposable in
            AF.request(url, headers: header)
                .responseDecodable(of: Response<[Alarm]>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        if response.code == 201 {
                            guard let alarms = response.result else { return }
                            var localAlarms = [LocalAlarm]()
                            alarms.forEach {
                                let alarmId = String($0.id)
                                let notice = $0.musicalNotice
                                
                                $0.alarmTimes.forEach {
                                    let localAlarm = LocalAlarm(
                                        alarmId: alarmId,
                                        notice: notice,
                                        beforeMin: $0)
                                    localAlarms.append(localAlarm)
                                }
                            }
                            
                            let filteredLocalAlarms = localAlarms.filter { $0.noticeId == notice.id }
                            
                            observer.onNext(filteredLocalAlarms)
                            observer.onCompleted()
                        } else {
                            print("[\(response.code)] \(response.message)")
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[getAllAlarms 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func postNoticeAlarms(notice: MusicalNotice, alarmTimes: [Int]) {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/alarms"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]
                
        let body: [String: Any] = [
            "musicalNoticeId": notice.id ?? "",
            "alarmTimes": alarmTimes
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
            .responseDecodable(of: Response<AlarmResult>.self) { [weak self] response in
            switch response.result {
            case .success(let response):
                print("[\(response.code)] \(response.message)")

                var localAlarms = [LocalAlarm]()
                
                alarmTimes.forEach { time in
                    guard let alarmId = response.result?.id else { return }
                    let localAlarm = LocalAlarm(
                        alarmId: String(alarmId),
                        notice: notice,
                        beforeMin: time
                    )
                    localAlarms.append(localAlarm)
                }
                
                localAlarms.forEach { [weak self] in
                    self?.userNotificationService.sendNotification(alarm: $0)
                }
            case .failure(let error):
                print("[알람 등록 실패] \(error.localizedDescription)")
            }
        }
    }
    
    func deleteNoticeAlarms(alarms: [LocalAlarm], completion: @escaping (Bool) -> Void) {
        let alarmId = alarms[0].alarmId
        
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/alarms/\(alarmId)"
        urlComponents?.path = path

        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }
                
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]

        AF.request(url, method: .delete, headers: header)
            .responseDecodable(of: Response<AlarmResult>.self) { [weak self] response in
            switch response.result {
            case .success(let response):
                print("[\(response.code)] \(response.message)")
                completion(true)
                self?.userNotificationService.cancelNotification(alarms: alarms)
            case .failure(let error):
                print("[알람 삭제 실패] \(error.localizedDescription)")
            }
        }
    }
    
    func updateNoticeAlarms(savedLocalAlarms: [LocalAlarm], notice: MusicalNotice, newAlarmTimes: [Int]) {
        deleteNoticeAlarms(alarms: savedLocalAlarms) { [weak self] success in
            if success {
                if !newAlarmTimes.isEmpty {
                    self?.postNoticeAlarms(notice: notice, alarmTimes: newAlarmTimes)
                }
            }
        }
    }
}
