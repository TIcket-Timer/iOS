//
//  UserService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/25.
//

import RxSwift
import Alamofire

class UserService {
    static let shared = UserService()
    
    private let baseUrl = Server.baseUrl.rawValue

    func getUserInfo() -> Observable<User> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/members"
        urlComponents?.path = path

        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<User>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        if response.code == 200 {
                            guard let user = response.result else { return }
                            observer.onNext(user)
                            observer.onCompleted()
                        } else {
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[유저 정보 가져오기 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }

            return Disposables.create()
        }
    }
    
    func updateUserNickname(nickname: String) {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/members/nickname"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }
                
        let body: [String: Any] = [
            "name": nickname
        ]
        
        AF.request(url, method: .patch, parameters: body, encoding: JSONEncoding.default, interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<String>.self) { response in
            switch response.result {
            case .success(let response):
                print("[\(response.code)] \(response.message) 변경된 넥네임: \(response.result ?? "")")
            case .failure(let error):
                print("[닉네임 업데이트 실패] \(error.localizedDescription)")
            }
        }
    }
    
    func getSiteAlarmSettings() -> Observable<PushAlarmSetting> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/members/alarms"
        urlComponents?.path = path

        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<PushAlarmSetting>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        print("[인터파크: \(response.result?.interAlarm ?? false), 멜론: \(response.result?.melonAlarm ?? false), 예스24: \(response.result?.yesAlarm ?? false)]")
                        if response.code == 200 {
                            guard let setting = response.result else { return }
                            observer.onNext(setting)
                            observer.onCompleted()
                        } else {
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[사이트별 알람 설정 정보 가져오기 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }

            return Disposables.create()
        }
    }
    
    func updateSiteAlarmSetting(site: Site, isOn: Bool) {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/members/alarms"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }
                
        let body: [String: Any] = [
            "site": site.siteLowercase,
            "bool": isOn
        ]

        AF.request(url, method: .patch, parameters: body, encoding: JSONEncoding.default, interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<PushAlarmSettingResult>.self) { response in
            switch response.result {
            case .success(let response):
                print("[\(response.code)] \(response.message) [\(response.result?.site ?? ""): \(response.result?.bool ?? false)]")
            case .failure(let error):
                print("[사이트별 알람 설정 실패] \(error.localizedDescription)")
            }
        }
    }
    
    func updateAllSiteAlarmSettings(settings: PushAlarmSetting) {
        updateSiteAlarmSetting(site: .interpark, isOn: settings.interAlarm)
        updateSiteAlarmSetting(site: .melon, isOn: settings.melonAlarm)
        updateSiteAlarmSetting(site: .yes24, isOn: settings.yesAlarm)
    }
}
