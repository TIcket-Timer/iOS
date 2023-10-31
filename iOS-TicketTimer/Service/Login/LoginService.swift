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
                case .failure(let error):
                    completion(false)
                }
            }
    }
    
    func login(with socialType: SocialLoginType) -> Observable<SocialLoginResult> {
        switch socialType {
        case .kakao:
            return kakaoLoginService.login()
        case .apple:
            return Observable.just(SocialLoginResult(token: "", SocialLoginType: .apple))
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
        print("[Authorization: \(token)]")
        print("[resource: \(type.rawValue)]")
        return Observable.create { observer -> Disposable in
            AF.request(url, headers: header)
                .responseDecodable(of: Response<LoginResult>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        guard let result = response.result else { return }
                        print("#1")
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        print("#2")
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
