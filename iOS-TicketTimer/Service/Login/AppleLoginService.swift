//
//  AppleLoginService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/01.
//

import RxSwift
import AuthenticationServices

class AppleLoginService: NSObject {
    
    private let loginResultSubject = PublishSubject<SocialLoginResult>()
    
    func login() -> Observable<SocialLoginResult> {
        appleLogin()
        return loginResultSubject.asObservable()
    }

    func logout() {
        
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let window = sceneDelegate?.window
        return window!
    }

    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = credential.identityToken,
            let identifyTokenString = String(data: identityToken, encoding: .utf8)
        else { return }
            
        let result = SocialLoginResult(token: identifyTokenString, SocialLoginType: .apple)
        self.loginResultSubject.onNext(result)
    }
    
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) { }
}
