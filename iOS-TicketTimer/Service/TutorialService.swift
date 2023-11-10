//
//  TutorialService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/10.
//

import Foundation

class TutorialService {
    static let shared = TutorialService()
    
    func checkTutorial() -> Bool {
        return UserDefaults.standard.bool(forKey: "isTutorialCompleted")
    }
    
    func saveTutorial(isCompleted: Bool) {
        UserDefaults.standard.set(isCompleted, forKey: "isTutorialCompleted")
    }
}
