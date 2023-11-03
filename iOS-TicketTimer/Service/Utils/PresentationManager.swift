//
//  PresentationManager.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/31.
//

import UIKit

class PresentationManager {
    static let shared = PresentationManager()

    func changeRootVC(_ viewController: UIViewController, animated: Bool = true) {
        guard
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else { return }

        if animated {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        } else {
            window.rootViewController = viewController
        }
    }
}
