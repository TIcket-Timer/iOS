//
//  SceneDelegate.swift
//  iOS-TicketTimer
//
//  Created by Jinhyung Park on 2023/08/01.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let LaunchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = LaunchScreen
        
        checkLogin()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}

extension SceneDelegate {
    private func checkLogin() {
        AuthService.shared.checkLogin { [weak self] isLogin in
            let rootViewController: UIViewController
            if isLogin {
                rootViewController = UINavigationController(rootViewController: TabBarViewController())
            } else {
                rootViewController = UINavigationController(rootViewController: LoginViewController())
            }
            UIView.transition(with: self?.window ?? UIWindow(), duration: 0.3, options: .transitionCrossDissolve, animations: {
                self?.window?.rootViewController = rootViewController
            })
        }
    }
}
