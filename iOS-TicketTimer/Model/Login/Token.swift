//
//  Auth.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import Foundation

struct RefreshTokenResult: Codable {
    let accessToken: String
    let refreshToken: String
}
