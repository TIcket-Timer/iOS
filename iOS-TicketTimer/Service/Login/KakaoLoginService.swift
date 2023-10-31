//
//  KakaoLoginService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/27.
//

import RxSwift

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser

class KakaoLoginService {
    
    // MARK: Internal

    func login() -> Observable<SocialLoginResult> {
        if UserApi.isKakaoTalkLoginAvailable() {
            return loginWithKakaoApp()
        } else {
            return loginWithKakaoAccount()
        }
    }

    func logout() {
        UserApi.shared.logout(completion: { _ in })
    }

    // MARK: Private
    
    private func loginWithKakaoApp() -> Observable<SocialLoginResult> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .map { oauthToken in
                return SocialLoginResult(token: oauthToken.accessToken, SocialLoginType: .kakao)
            }
    }
    
    private func loginWithKakaoAccount() -> Observable<SocialLoginResult> {
        return UserApi.shared.rx.loginWithKakaoAccount()
            .map { oauthToken in
                return SocialLoginResult(token: oauthToken.accessToken, SocialLoginType: .kakao)
            }
    }
}
