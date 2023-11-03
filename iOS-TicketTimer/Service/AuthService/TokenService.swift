//
//  TokenService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/27.
//

import RxSwift

class TokenService {
    static let shared = TokenService()
    
    func saveAccessToken(with token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    func saveRefreshToken(with token: String) {
        UserDefaults.standard.set(token, forKey: "refreshToken")
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}
    
