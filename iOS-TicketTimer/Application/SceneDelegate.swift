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

        if UserDefaults.standard.bool(forKey: "isLogin") {
            self.window?.rootViewController = UINavigationController(rootViewController: TabBarViewController())
        } else {
            self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }

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
    func changeRootVC(_ vc: UIViewController) {
        guard let window = self.window else { return }
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
      }
}
