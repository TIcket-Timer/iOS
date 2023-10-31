//
//  LoginService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/27.
//

import RxSwift
import Alamofire

class LoginService {
    static let shared = LoginService()

    private let kakaoLoginService = KakaoLoginService()
    
    func checkLogin() -> Observable<Bool> {
        var urlComponents = URLComponents(string: Server.baseUrl.rawValue)
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
                        print("[\(response.code): \(response.message)]")
                        if response.code == 200 {
                            observer.onNext(true)
                            observer.onCompleted()
                        } else {
                            observer.onNext(false)
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[로그인 상태 확인 실패] \(error.localizedDescription)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                }

            return Disposables.create()
        }
    }
    
    func login(with socialType: SocialLoginType) -> Observable<SocialLoginResult> {
        switch socialType {
        case .kakao:
            return kakaoLoginService.login()
        case .apple:
            return kakaoLoginService.login()
        }
    }
    
    func sendToken(_ type: SocialLoginType, with token: String) -> Observable<LoginResult> {
        var urlComponents = URLComponents(string: Server.baseUrl.rawValue)
        let path = "/api/oauth2/\(type)"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "resource": type.rawValue
        ]
        
        return Observable.create { observer -> Disposable in
            AF.request(url, headers: header)
                .responseDecodable(of: Response<LoginResult>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        guard let result = response.result else { return }
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        print("\(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    func logout() {
        kakaoLoginService.logout()
    }
    
    func saveSocialLoginType(_ type: String) {
        UserDefaults.standard.set(type, forKey: "socialLoginType")
    }
}
