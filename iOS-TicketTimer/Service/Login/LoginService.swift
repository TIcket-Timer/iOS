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
    private let appleLoginService = AppleLoginService()
    
    func checkLogin(completion: @escaping (Bool) -> Void) {
        var urlComponents = URLComponents(string: Server.baseUrl.rawValue)
        let path = "/api/members"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return completion(false)
        }
        
        AF.request(url, interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<User>.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure(_):
                    completion(false)
                }
            }
    }
    
    func login(with socialType: SocialLoginType) -> Observable<SocialLoginResult> {
        switch socialType {
        case .kakao:
            return kakaoLoginService.login()
        case .apple:
            return appleLoginService.login()
        }
    }
    
    func sendToken(_ type: SocialLoginType, with token: String) -> Observable<LoginResult> {
        var urlComponents = URLComponents(string: Server.baseUrl.rawValue)
        let path = "/api/oauth2"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        var header: HTTPHeaders = [
            "Authorization": token,
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
        TokenService.shared.deleteToken()
    }
    
    func saveSocialLoginType(_ type: String) {
        UserDefaults.standard.set(type, forKey: "socialLoginType")
    }
}
