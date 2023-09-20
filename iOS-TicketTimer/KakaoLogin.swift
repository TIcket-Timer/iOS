//
//  KakaoLogin.swift
//  
//
//  Created by Jinhyung Park on 2023/08/20.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire


struct ServerResponse: Codable {
    let code: Int
    let message: String
    let result: ResultData?
    
    struct ResultData: Codable {
        let accessToken: String
        let refreshToken: String
    }
}

class KakaoLogin: UIViewController {
    
    @IBOutlet weak var responseLabel: UILabel!
    
    // Kakao 관련 정보 저장
    var email: String = ""
    var accessToken: String = ""
    var refreshToken: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    _ = oauthToken
                    self.getUserInfo(oauthToken: oauthToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    _ = oauthToken
                    self.getUserInfo(oauthToken: oauthToken)
                }
            }
        }
    }
    
    private func getUserInfo(oauthToken: OAuthToken?) {
        UserApi.shared.me { [weak self] user, error in
            guard let self = self, error == nil, let user = user,
                  let kakaoAccount = user.kakaoAccount, let profile = kakaoAccount.profile else {
                return
            }
            
            self.email = kakaoAccount.email ?? ""
            self.accessToken = oauthToken?.accessToken ?? ""
            self.refreshToken = oauthToken?.refreshToken ?? ""
            self.name = profile.nickname ?? ""
            
            print("\(name)")
            print("\(accessToken)")
            print("\(refreshToken)")
            
            self.sendTokensToServer()
        }
    }

    private func sendTokensToServer() {
        let urlString = "http://43.202.78.122:8080/api/oauth2/kakao"
        guard let url = URL(string: urlString) else {
            print("URL 형식이 잘못되었습니다.")
            return
        }
//        let parameters: [String: Any] = ["accessToken": accessToken, "refreshToken": refreshToken]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)",
                                    "resource": "kakao"]
                                    //"Content-Type": "application/json"]

        AF.request(url,
                   method: .get,
//                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let serverResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                        print("code: \(serverResponse.code)")
                        print("message: \(serverResponse.message)")
                        if let result = serverResponse.result {
                            print("accessToken: \(result.accessToken)")
                            print("refreshToken: \(result.refreshToken)")

                            DispatchQueue.main.async {
                                self.responseLabel.text = "code: \(serverResponse.code)\nmessage: \(serverResponse.message)\naccessToken: \(result.accessToken)\nrefreshToken: \(result.refreshToken)"
                            }
                        }
                    } catch {
                        print("디코딩 실패: \(error.localizedDescription)")
                    }

                case .failure(let error):
                    print("토큰 전송에 실패했습니다.")
                    if let data = response.data, let serverErrorResponse = String(data: data, encoding: .utf8) {
                        print("서버 에러 메시지: \(serverErrorResponse)")
                    } else {
                        print("문제 발생: \(error.localizedDescription)")
                    }
                }
            }
    }
}
