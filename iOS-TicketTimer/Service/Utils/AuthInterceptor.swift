//
//  AuthInterceptor.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/27.
//

import RxSwift
import Alamofire

class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
        print("[accessToken: \(accessToken)]")
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        var urlComponents = URLComponents(string: Server.baseUrl.rawValue)
        let path = "/api/members"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }
        
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("[refreshToken error]")
            return
        }
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(refreshToken)"
        ]
        
        AF.request(url, headers: header)
            .responseDecodable(of: Response<RefreshTokenResult>.self) { response in
                switch response.result {
                case .success(let response):
                    if response.code == 200 {
                        guard let token = response.result else { return }
                        TokenService.shared.saveAccessToken(with: token.accessToken)
                        TokenService.shared.saveRefreshToken(with: token.refreshToken)
                        completion(.retry)
                        print("[토큰 업데이트 성공]")
                    } else {
                        completion(.doNotRetryWithError(error))
                        print("[리프레시 토큰 만료]")
                    }
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                    print("[토큰 업데이트 실패] \(error.localizedDescription)")
                }
            }
    }
}
