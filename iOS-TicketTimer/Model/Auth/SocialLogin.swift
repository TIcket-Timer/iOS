//
//  SocialLogin.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/31.
//

import Foundation

enum SocialLoginType: String {
    case kakao = "kakao"
    case apple = "apple"
}

struct SocialLoginResult {
    let token: String
    let SocialLoginType: SocialLoginType
}
